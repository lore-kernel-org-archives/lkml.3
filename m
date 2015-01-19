Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbbASRMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 12:12:38 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59032 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbbASRMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 12:12:36 -0500
Message-ID: <54BD3B49.4050203@wwwdotorg.org>
Date: Mon, 19 Jan 2015 10:13:45 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Stefan Wahren <stefan.wahren@i2se.com>, lee@kernel.org,
        linux@arm.linux.org.uk, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4 V2] dt-bindings: Add root properties for Raspberry
 Pi
References: <1421665231-28221-1-git-send-email-stefan.wahren@i2se.com>
In-Reply-To: <1421665231-28221-1-git-send-email-stefan.wahren@i2se.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 04:00 AM, Stefan Wahren wrote:
> This patch adds root compatible properties for the following boards:
> - Raspberry Pi Model A
> - Raspberry Pi Model A+
> - Raspberry Pi Model B
> - Raspberry Pi Model B (no P5)
> - Raspberry Pi Model B rev2
> - Raspberry Pi Model B+
> - Raspberry Pi Compute Module

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

This seems sane to me. One thing I should have asked: What compatible 
values does the RPi Foundation's downstream for all these cases? 
Aligning with that would be nice if possible.
