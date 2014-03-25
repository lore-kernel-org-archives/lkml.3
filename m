Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaCYThX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:37:23 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:61901 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbaCYThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:37:20 -0400
MIME-Version: 1.0
In-Reply-To: <1395774051-22470-1-git-send-email-michele@acksyn.org>
References: <1395774051-22470-1-git-send-email-michele@acksyn.org>
Date: Tue, 25 Mar 2014 20:37:18 +0100
Message-ID: <CAN_we7MZW+iympXsg2Z6N5YtPydxBY3RLv4UH-0PnnCRXcuJwQ@mail.gmail.com>
Subject: Re: [PATCH] USB: serial: ftdi_sio: add id for Brainboxes VX-001 ExpressCard
From: Daniele Forsi <dforsi@gmail.com>
To: Michele Baldessari <michele@acksyn.org>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-25 20:00 GMT+01:00 Michele Baldessari:

> Custom VID/PID for Brainboxes VX-001 ExpressCard RS232 as reported in

> + * Product: ExpressCard 1 Port RS2323

there is a stray trailing "3"

-- 
Daniele Forsi
