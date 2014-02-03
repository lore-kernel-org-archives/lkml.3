Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaBCRfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 12:35:20 -0500
Received: from plane.gmane.org ([80.91.229.3]:40018 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbaBCRfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 12:35:18 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: [PATCH resend 1/2] bcache: Use %zi to format size_t
Date: Mon, 03 Feb 2014 11:34:49 -0600
Message-ID: <lcojvq$n46$1@ger.gmane.org>
References: <1391435387-13062-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-173-57-186-106.dllstx.fios.verizon.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
In-Reply-To: <1391435387-13062-1-git-send-email-geert@linux-m68k.org>
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shouldn't size_t use %zu?

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
           Sent from the cloud -- where it's already tomorrow
========================================================================

