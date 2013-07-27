Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3G0Ono (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 10:43:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62194 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3G0Onn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 10:43:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/1] drivers: misc: Add support for ANDROID_PMEM
Date: Sat, 27 Jul 2013 16:43:38 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: =?iso-8859-1?q?B=E1lint_Czobor?= <czoborbalint@gmail.com>,
        linux-kernel@vger.kernel.org
References: <1374662321-27152-1-git-send-email-czoborbalint@gmail.com> <CAL6DFdeJFz2F5FP+0w44ygfATDkNQTBpV7ODkbBFwerq50H4Rw@mail.gmail.com> <20130726145608.GA27289@kroah.com>
In-Reply-To: <20130726145608.GA27289@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201307271643.38995.arnd@arndb.de>
X-Provags-ID: V02:K0:78ae+UURrbLLCKznbcFvXyhzVnp6su17rbSgFBJm2sL
 hItAQIu8yaVUUZ0MBLMLYSSKjlPBJ2RvIQwMODf6E66bup3c0p
 AaezpAprdEJLvded5folKuDH93C503nnSEkPRIbofGELfhOf+Z
 aZXPzH26+lcRkfa7dZPQiOAb7ZqkTHRPOhxIJQrd4cfgeK+kaR
 8hxqfX1QxihXhU6NG2k0fQ5YfLdzytigpsrX0FczUZVE+MT69x
 AcJ+E9l3WdCFhs7IXwpSDylcghGvbWz2RTi+Y1hnYOkdk7dDsm
 taAAM2L6IQllqEZlZjdz+Qt69r2IrTK1dFPu39ZUgG23UeSNUS
 VGzsf1ruoGrFSuLlVj3E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 July 2013, Greg Kroah-Hartman wrote:
> On Fri, Jul 26, 2013 at 02:53:21PM +0200, Bálint Czobor wrote:
> > Thank you for the info.
> > However some devices still use it, sorry, I haven't seen that commit.
> 
> No modern Android devices should use pmem, only obsolete ones, right?
> That's why the code was removed.
> 
> Do you have a device that requires this?
> 
> You also mixed in a lot of device-specific changes, do you need those to
> be applied?  If so, please make up a separate patch and submit it.

One particular problem is that it adds a dependency between the pmem driver
and the mach-msm directory for header files. This conflicts with the attempt
to remove all global header files from mach-msm, which is needed to support
multiplatform kernels.

	Arnd
