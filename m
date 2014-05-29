Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965114AbaE2PkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:40:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154AbaE2PkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:40:06 -0400
Date: Thu, 29 May 2014 08:43:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Andy Gross <agross@codeaurora.org>, linux-kernel@vger.kernel.org,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [Patch v2 4/4] tty: serial: msm: Remove direct access to GSBI
Message-ID: <20140529154342.GA28679@kroah.com>
References: <1398357082-5102-1-git-send-email-agross@codeaurora.org>
 <1398357082-5102-5-git-send-email-agross@codeaurora.org>
 <A56B810D-869A-4E4F-BC29-C9B0F6CDCE79@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A56B810D-869A-4E4F-BC29-C9B0F6CDCE79@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 10:14:35AM -0500, Kumar Gala wrote:
> 
> On Apr 24, 2014, at 11:31 AM, Andy Gross <agross@codeaurora.org> wrote:
> 
> > This patch removes direct access of the GSBI registers.  GSBI configuration
> > should be done through the GSBI driver directly.
> > 
> > Signed-off-by: Andy Gross <agross@codeaurora.org>
> > ---
> > drivers/tty/serial/msm_serial.c |   48 ++-------------------------------------
> > drivers/tty/serial/msm_serial.h |    5 ----
> > 2 files changed, 2 insertions(+), 51 deletions(-)
> 
> Greg,
> 
> Any update on pulling this is for next?

I thought this was going through someone else's tree, sorry.  And, there
seemd to be a second set of patches for this, which I don't have
anywhere :(

If you want me to take all of these, or just this one, Andy, can you
please resend?

thanks,

greg k-h
