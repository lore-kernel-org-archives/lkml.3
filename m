Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936369Ab3DQRjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:39:08 -0400
Received: from n26.netmark.pl ([94.124.9.61]:40881 "EHLO n26.netmark.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936238Ab3DQRjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:39:05 -0400
Date: Wed, 17 Apr 2013 19:39:03 +0200
From: Marcin Szewczyk <Marcin.Szewczyk@wodny.org>
To: linux-kernel@vger.kernel.org
Subject: How to override GMA500 resolution set by BIOS?
Message-ID: <20130417173903.GB4140@magazyn-ziarno.chello.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - n26.netmark.pl
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - wodny.org
X-Get-Message-Sender-Via: n26.netmark.pl: authenticated_id: wodny/from_h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've got a problem with GMA500 on my EVOC EC2-1711. The graphics
adapter's resolution is set by selecting an option in BIOS but I would
like to override it. Can kernel or Xorg do this?

There are two modes "almost" right for an 800x600 16bit LVDS screen I
have.  The first one is 800x600 but in 24bit LVDS mode, so colors are
mangled. The second one is 800x480 16bit -- colors are right, but the
screen cuts the image at line 480.

I've tried video=, overwriting modes via patched 915resolution, vga= and
Xorg modesetting driver. Nothing works.

Does anyone know if it's possible to override the mode?

-- 
Marcin Szewczyk                       http://wodny.org
mailto:Marcin.Szewczyk@wodny.borg  <- remove b / usuń b
xmpp:wodny@ubuntu.pl                  xmpp:wodny@jabster.pl
