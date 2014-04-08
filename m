Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbaDHN3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:29:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210AbaDHN3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:29:52 -0400
Date: Tue, 8 Apr 2014 18:59:38 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Paul Bolle <pebolle@tiscali.nl>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] initramfs: remove "compression mode" choice
In-Reply-To: <1396958857.26620.35.camel@x220>
Message-ID: <alpine.LFD.2.10.1404081851490.29689@wniryva.cad.erqung.pbz>
References: <1396958857.26620.35.camel@x220>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Hello Paul,

+-- On Tue, 8 Apr 2014, Paul Bolle wrote --+
| "Built-in initramfs compression mode" choice is a set of knobs connected
| to nothing. The entire choice can safely be removed.

   This patch has already been submitted upstream; though not sure if it is 
merged yet.

Please see -> https://lkml.org/lkml/2013/11/25/21

@Andrew: is it queued to be merged upstream?

Thank you.
--
 - P J P
