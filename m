Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaAIQBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:01:13 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:55312 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaAIQBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:01:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAAZheXmEuSB0C-xDS1HWa2npX13s5TdPfpxfmnYQU6y4r9T66A@mail.gmail.com>
References: <jim_baxter@mentor.com>
	<1373999390-14548-1-git-send-email-jim_baxter@mentor.com>
	<20130716193714.GA19924@merkur.ravnborg.org>
	<51E5B7FF.9080004@mentor.com>
	<CAAZheXmEuSB0C-xDS1HWa2npX13s5TdPfpxfmnYQU6y4r9T66A@mail.gmail.com>
Date: Thu, 9 Jan 2014 21:01:06 +0500
Message-ID: <CAAZheX=QjTQtp_BPE=e1U3ZwFiWTRPbE=T0yYnsxHf05t1DvsQ@mail.gmail.com>
Subject: Fwd: [RFC] kbuild: Build samples directory with make modules
From: Syed Muhammad Mohsin Kazmi <08beesmmkazmi@seecs.edu.pk>
To: Jim Baxter <jim_baxter@mentor.com>, "cc: Sam Ravnborg" <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any specific reason that this patch is ignored still yet?
Compiling the uImage and modules together add the support of samples?
Shouldn't it be compiled as a module separately and that is correct
behavior in case of if samples are compiled as loadable modules?

Thanks,
Mohsin Kazmi


On Wed, Jul 17, 2013 at 2:15 AM, Jim Baxter <jim_baxter@mentor.com> wrote:
>
> On 16/07/13 20:37, Sam Ravnborg wrote:
> > On Tue, Jul 16, 2013 at 07:29:50PM +0100, Jim Baxter wrote:
> >> If CONFIG_SAMPLES is enabled with any of the sample
> >> modules enabled, they are only built if the make command
> >> includes uImage and modules (i.e. make uImage modules).
> >
> > With the current location samples are built when you build vmlinux.
> > And vmlinux is implicit when you just type "make".
> >
> > With the suggestion you have samples are built when you do "make modules".
> > IMO this is less logical than to built them with vmlinux as we do today.
> >
> >       Sam
> >
>
> Hi,
>
> I am building it with:
> make uImage
> make modules
>
> At least bitbake in Yocto and Openembedded is.
>
> Running make on it's own is the equivalent of:
> make vmlinux modules
>
> which builds the samples directory, however if you run:
> make vmlinux
> make modules
>
> Then the Samples are not built, that is what I am trying to fix.
>
> Thank you,
> Jim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
