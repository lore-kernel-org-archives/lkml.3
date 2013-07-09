Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3GIQgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:36:18 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57616 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3GIQgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:36:16 -0400
Date: Tue, 09 Jul 2013 11:27:53 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] menuconfig: Allow j/k to move down/up the menu
To: =?iso-8859-1?b?U/ZyZW4=?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
References: <1373023979-20537-1-git-send-email-artagnon@gmail.com>
	<1373151605.27613.9@driftwood>
	<478d866c-606e-42de-9779-6ae18d70e7f1@CO1EHSMHS014.ehs.local>
In-Reply-To: <478d866c-606e-42de-9779-6ae18d70e7f1@CO1EHSMHS014.ehs.local>
	(from soren.brinkmann@xilinx.com on Mon Jul  8 18:08:41 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1373387273.27613.30@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 06:08:41 PM, Sören Brinkmann wrote:
> On Sat, Jul 06, 2013 at 06:00:05PM -0500, Rob Landley wrote:
> > On 07/05/2013 06:32:59 AM, Ramkumar Ramachandra wrote:
> > >Like in Vim.
> > >
> > >Cc: Michal Marek <mmarek@suse.cz>
> > >Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> > >---
> > > Unsure why nobody has done this yet.
> >
> > While you're at it, why don't you add the ws up and down bindings
> > from World of Warcraft?
> >
> > The reason nobody has done this yet is that vi predates the
> > invention of cursor keys. They keyboards Bill Joy was using in the
...
> > And now you know _why_ Linux is over 20 years old and has never
> > needed this.
> 
> Well, one advantage of these key bindings is, that you don't have to
> move your hands away from the base line. And as vim user I find myself
> using vim key sequences in all tools. I cannot even count how many
> processes I accidentally killed because I tried to scroll using 'k' in
> htop where it does 'kill'.

A ringing endorsement.

Rob