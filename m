Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbaLCVld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:41:33 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51735 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaLCVlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:41:31 -0500
Date: Wed, 3 Dec 2014 13:41:28 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the driver-core tree with the
 net-next tree
Message-ID: <20141203214128.GB8974@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Arend van Spriel <arend@broadcom.com>, linux-kernel@vger.kernel.org
References: <20141201181933.6dfaad66@canb.auug.org.au>
 <547C19ED.10201@broadcom.com>
 <20141203083655.GA5418@hudson.localdomain>
 <20141203105148.GA7633@hudson.localdomain>
 <547F06BC.8060000@broadcom.com>
 <20141203210659.GA8974@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141203210659.GA8974@hudson.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 01:06:59PM -0800, Jeremiah Mahler wrote:
> Arend,
> 
> On Wed, Dec 03, 2014 at 01:49:00PM +0100, Arend van Spriel wrote:
> > On 12/03/14 11:51, Jeremiah Mahler wrote:
> > >On Wed, Dec 03, 2014 at 12:36:55AM -0800, Jeremiah Mahler wrote:
> > >>all,
> > >>
> > >>On Mon, Dec 01, 2014 at 08:34:05AM +0100, Arend van Spriel wrote:
> > >>>On 01-12-14 08:19, Stephen Rothwell wrote:
> > >>>>Hi Greg,
> > >>>>
[...]
> > >
> > >I took a look at the patch that is causing this problem (d32394fae95).
> > >My config negates everything in the patch except for a one line change
> > >to ath9k/pci.c.  If I remove this change (shown below) the problem goes
> > >away.
> > 
> > Ok. But then it will likely crash when you cat one of the changed debugfs
> > files. Guess this commit needs to be reverted entirely.
> > 
> 
> On my machine ATH9K_DEBUFS is disabled so none of that code is used.
> 
> I can try enabling it and see if a cat will crash it.
> 

With ATH9K_DEBUGFS enabled, cat works fine on the files that were
changed.

/sys/kernel/debug/ieee80211/phy0/ath9k/
  dma
  interrupt
  xmit
  queues

> > Regards,
> > Arend
> > 
[...]
> 
> -- 
> - Jeremiah Mahler

-- 
- Jeremiah Mahler
