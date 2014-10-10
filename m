Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaJJTZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 15:25:29 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:43670 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaJJTZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 15:25:28 -0400
Message-ID: <5438329D.1040600@gmail.com>
Date: Fri, 10 Oct 2014 12:25:17 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: arnd@arndb.de, computersforpeace@gmail.com,
        thomas.petazzoni@free-electrons.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/2] bus: brcmstb_gisb: misc fixes
References: <1411408966-15390-1-git-send-email-f.fainelli@gmail.com>
In-Reply-To: <1411408966-15390-1-git-send-email-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On 09/22/2014 11:02 AM, Florian Fainelli wrote:
> Hi Arnd,
> 
> This patch set contains two small fixes for the Broadcom GISB bus
> arbiter code. First patch makes sure we do register a fault code for
> ARM platforms, second patch is a fix when the code is used on a PM
> capable system.

Once the merge window re-opens in about a week from now, how do you want
me to submit those patches? Do you want them as part of a brcmstb pull
request, or something else?

Thank you!

> 
> Florian Fainelli (2):
>   bus: brcmstb_gisb: register the fault code hook
>   bus: brcmstb_gisb: save and restore GISB timeout
> 
>  drivers/bus/brcmstb_gisb.c | 45 +++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 39 insertions(+), 6 deletions(-)
> 

