Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbaHLRAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:00:38 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33619 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaHLRAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:00:36 -0400
Date: Tue, 12 Aug 2014 10:00:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: wacom - Fix compiler warning if !CONFIG_PM
Message-ID: <20140812170033.GA5563@core.coreip.homeip.net>
References: <1407604023-7429-1-git-send-email-geert@linux-m68k.org>
 <alpine.LNX.2.00.1408092238290.15220@pobox.suse.cz>
 <20140811144238.GA10029@mail.corp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140811144238.GA10029@mail.corp.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 10:42:38AM -0400, Benjamin Tissoires wrote:
> On Aug 09 2014 or thereabouts, Jiri Kosina wrote:
> > On Sat, 9 Aug 2014, Geert Uytterhoeven wrote:
> > 
> > > If CONFIG_PM is not set:
> > > 
> > > drivers/hid/wacom_sys.c:1436: warning: ‘wacom_reset_resume’ defined but
> > > not used
> > > 
> > > Protect the unused functions by #ifdef CONFIG_PM to fix this.
> > > 
> > > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > 
> > Thanks Geert.
> > 
> > hid-wacom is in a sort of temporary mode of operation, being moved from 
> > Input to HID driver.
> > 
> > Adding Benjamin and Dmitry to CC, as this will likely still go through 
> > Dmitry's queue.
> > 
> 
> Thanks for fixing this Geert.
> 
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Applied, thank you.

-- 
Dmitry
