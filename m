Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab3CKNea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:34:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50553 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3CKNe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:34:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [char-misc-next 01/12 v3] mei: Rename mei_device to mei_host
Date: Mon, 11 Mar 2013 13:34:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Winkler, Tomas" <tomas.winkler@intel.com>
References: <1360694222-27632-1-git-send-email-sameo@linux.intel.com> <20130220105731.GT18295@sortiz-mobl> <20130311104418.GA1438@zurbaran>
In-Reply-To: <20130311104418.GA1438@zurbaran>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303111334.21652.arnd@arndb.de>
X-Provags-ID: V02:K0:jNfv/dfO9oo+GhJ4Z73ARajguwlWi/fdTHD37sY5Syn
 huOuR9lCD6+v2hj0oHNyMR7X2uGENlV1zZNtpqA6YpI63hwAkD
 kTacx8/DOxEeCPtxNXbu0WsVYW/1jNzgf+0FsI6DSr9XWgFC+r
 35XTkc046yVNyEPlCvG5jP00aeS5FHpxgJuQO+l4N7UQTHOMSx
 Ul0vV/H/wA2j/bmy2qmqOJTmDxYCWkGTdQidBOXjo1kPTY+c7w
 VBcovOAo4gUhe+OdufY3/mDBLkYFE0q8YElqsOC9264FRpfaF9
 f9BGokdt1eT75gCflw+R1Urehm1nr6qM0eDLoboJUZfyulgw3b
 xV+1lf2QdXfmHkdpoWEQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 March 2013, Samuel Ortiz wrote:
> > I don't have a strong opinion here, so that would be fine with me.
> > Greg, Arnd, would mei_cl_device and mei_cl_driver be an acceptable compromise?
> I'm re-opening this topic now that the merge window is closed: So would you
> guys take mei_cl_device and mei_cl_driver as an acceptable solution or (as you
> hinted earlier) are mei_device and mei_driver the only naming scheme that
> you'd accept ?

I'd prefer the latter, but I wouldn't insist on it if you have good reasons
to use the former.

	Arnd
