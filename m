Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783Ab3GSP34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:29:56 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:48748 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760309Ab3GSP3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:29:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLFw4t-jwO4vDuMYfZA4uqH59h1c66xVPPFDO037OvGKSg@mail.gmail.com>
References: <1374245148-24031-1-git-send-email-alexj@rosedu.org>
 <CAOJsxLGEmjY6wTp99DKQ4ZKO2oXq6102MczbjCHTUReuCTq-fw@mail.gmail.com>
 <CAPhGq=b6_7=i3e=9gkT9s5JZ+hAPcu8T_S+M9Yt60nt3vA6Nrw@mail.gmail.com> <CAOJsxLFw4t-jwO4vDuMYfZA4uqH59h1c66xVPPFDO037OvGKSg@mail.gmail.com>
From: Alexandru Juncu <alexj@rosedu.org>
Date: Fri, 19 Jul 2013 18:29:34 +0300
X-Google-Sender-Auth: VTHvyCxyEolF6VSL5Oic1KX8Cnk
Message-ID: <CAPhGq=Y30i0RWJTcomt5sRdKX6RDzdGHBo5L9D6coH8O0ej6kA@mail.gmail.com>
Subject: Re: [PATCH] lustre:libcfs: remove redundant code.
To: Pekka Enberg <penberg@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "andreas.dilger" <andreas.dilger@intel.com>,
        "tao.peng" <tao.peng@emc.com>, driverdev <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 July 2013 18:21, Pekka Enberg <penberg@kernel.org> wrote:
> On Fri, Jul 19, 2013 at 6:13 PM, Alexandru Juncu <alexj@rosedu.org> wrote:
>> I was thinking the same thing, but I hesitated because I didn't know
>> how used it was and I didn't want to break something.
>
> "git grep cfs_strdup" suggests that nobody uses it so you could just
> remove it completely...

Did a grep on the tree and yes, it's not used. But It's in a staging
directory so maybe the rest of the code has not been pushed in yet.
