Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbaEOSQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:16:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55708 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaEOSQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:16:02 -0400
Message-ID: <5375045F.4030700@wwwdotorg.org>
Date: Thu, 15 May 2014 12:15:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: stefan@agner.ch, thierry.reding@gmail.com
CC: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, marcel@ziswiler.com
Subject: Re: [PATCH v2 1/3] ARM: tegra: enable MCP251x CAN controller and
 DS1307 RTC
References: <cover.1400103181.git.stefan@agner.ch> <4cc13e0aba03a5b2d3e5f4049d252956342b1dad.1400103181.git.stefan@agner.ch>
In-Reply-To: <4cc13e0aba03a5b2d3e5f4049d252956342b1dad.1400103181.git.stefan@agner.ch>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 03:45 PM, stefan@agner.ch wrote:
> From: Stefan Agner <stefan@agner.ch>
> 
> Toradex Colibri Evaluation Board uses the DS1307 RTC and the
> MCP251x CAN controller. The NVIDIA Tegra 3 based Colibri T30
> module can be used on this carrier board, hence enable those
> drivers in tegra_defonfig.
> 
> Furthermore the NVIDIA Tegra 3 based Apalis T30 module too
> contains two MCP251x CAN controller.

I already applied v1 of this one patch.
