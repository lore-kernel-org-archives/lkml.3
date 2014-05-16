Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbaEPS7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 14:59:45 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:35533 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbaEPS7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 14:59:44 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Samuel Chessman <chessman@tux.org>
Subject: Re: [PATCH 2/2] tlan: Enable link monitoring
Date: Fri, 16 May 2014 20:59:17 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1400263230-2599-1-git-send-email-linux@rainbow-software.org> <1400263230-2599-2-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1400263230-2599-2-git-send-email-linux@rainbow-software.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201405162059.17456.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2014 20:00:30 Ondrej Zary wrote:
> Enable old link monitoring code and modify it:
>  - control LINK LED
>  - use separate timer so it does not interfere with ACT LED
>  - reset adapter on link loss to restart autonegotiation
>    (required to switch between 10/100 Mbps on OC-2326)

Oops, sorry. This part is broken - the link comes up properly but no packets 
can be transferred then.

-- 
Ondrej Zary
