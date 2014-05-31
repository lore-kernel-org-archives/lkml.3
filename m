Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935103AbaEaDvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 23:51:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771AbaEaDvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 23:51:40 -0400
Date: Fri, 30 May 2014 20:51:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Olof Johansson <olof@lixom.net>
Cc: Kumar Gala <galak@codeaurora.org>, "arm@kernel.org" <arm@kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andy Gross <agross@codeaurora.org>
Subject: Re: [GIT PULL] qcom driver changes for v3.16-2
Message-ID: <20140531035127.GA2849@kroah.com>
References: <alpine.DEB.2.00.1405301138220.5291@galak-ubuntu.qualcomm.com>
 <20140530235720.GA27752@kroah.com>
 <CAOesGMjhFLD=Rkz0SqSav9qfAzWBCXLf03b=5=xj0uZzz6KwdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOesGMjhFLD=Rkz0SqSav9qfAzWBCXLf03b=5=xj0uZzz6KwdQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 08:08:42PM -0700, Olof Johansson wrote:
> On Fri, May 30, 2014 at 4:57 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, May 30, 2014 at 11:41:01AM -0500, Kumar Gala wrote:
> >> The following changes since commit 5d144e36b7c51612922fa05d37ff3a869261cc82:
> >>
> >>   soc: qcom: Add GSBI driver (2014-05-23 11:38:04 -0500)
> >>
> >> are available in the git repository at:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-drivers-for-3.16-2
> >>
> >> for you to fetch changes up to 31964ffebbb958c6cf289c7c12edd7530d6221b9:
> >>
> >>   tty: serial: msm: Remove direct access to GSBI (2014-05-29 11:06:20 -0500)
> >>
> >> ----------------------------------------------------------------
> >> Qualcomm ARM Based driver Updates for v3.16-2
> >>
> >> * Updated MSM uart driver to not access GSBI control registers
> >>
> >> ----------------------------------------------------------------
> >> Andy Gross (1):
> >>       tty: serial: msm: Remove direct access to GSBI
> >>
> >>  drivers/tty/serial/msm_serial.c | 48 ++---------------------------------------
> >>  drivers/tty/serial/msm_serial.h |  5 -----
> >>  2 files changed, 2 insertions(+), 51 deletions(-)
> >
> > Do you want me to take these in the tty tree?  Or are they going to go
> > through the arm tree(s) for other reasons (dependancies)?
> 
> In the other thread about this patch
> (http://marc.info/?l=linux-kernel&m=140137951814522&w=2), he claimed:
> 
> "I’ll send it via arm-soc as the related patches are going via that path."
> 
> I'm not fussed either way. I haven't touched these branches yet.

Ok, that's fine with me.

greg k-h
