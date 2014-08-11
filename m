Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaHKOmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:42:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbaHKOms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:42:48 -0400
Date: Mon, 11 Aug 2014 10:42:38 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: wacom - Fix compiler warning if !CONFIG_PM
Message-ID: <20140811144238.GA10029@mail.corp.redhat.com>
References: <1407604023-7429-1-git-send-email-geert@linux-m68k.org>
 <alpine.LNX.2.00.1408092238290.15220@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1408092238290.15220@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 09 2014 or thereabouts, Jiri Kosina wrote:
> On Sat, 9 Aug 2014, Geert Uytterhoeven wrote:
> 
> > If CONFIG_PM is not set:
> > 
> > drivers/hid/wacom_sys.c:1436: warning: ‘wacom_reset_resume’ defined but
> > not used
> > 
> > Protect the unused functions by #ifdef CONFIG_PM to fix this.
> > 
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Thanks Geert.
> 
> hid-wacom is in a sort of temporary mode of operation, being moved from 
> Input to HID driver.
> 
> Adding Benjamin and Dmitry to CC, as this will likely still go through 
> Dmitry's queue.
> 

Thanks for fixing this Geert.

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin

