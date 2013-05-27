Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab3E0RQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 13:16:05 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:52862 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3E0RQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 13:16:04 -0400
Message-ID: <1369674958.30083.0.camel@roadrunner.fritz.box>
Subject: Re: [PATCH] hid: driver for PS2/3 Buzz controllers
From: Colin Leitner <colin.leitner@googlemail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 27 May 2013 19:15:58 +0200
In-Reply-To: <alpine.LNX.2.00.1305271628540.3914@pobox.suse.cz>
References: <1369587150.4240.4.camel@roadrunner.fritz.box>
	 <alpine.LNX.2.00.1305271628540.3914@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> I this it'd actually make more sense to add this support to one of the two 
> existing drivers (*) we already have for Sony remote controllers -- either 
> hid-sony or hid-ps3remote both seem appropriate.
> 

I'll integrate the buzz code to hid-sony. Unfortunatly I can't test against
the six-axis controller as I don't own a Playstation.

Greetings,
	Colin


