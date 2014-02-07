Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaBGRsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:48:24 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:55963 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaBGRsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:48:22 -0500
Message-ID: <52F52A97.1010001@cogentembedded.com>
Date: Fri, 07 Feb 2014 21:48:55 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org
CC: Armin Schindler <mac@melware.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH 01/26] drivers: isdn: Rectify typing error in xdi_msg.h
References: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
In-Reply-To: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02/07/2014 03:18 PM, Rashika Kheria wrote:

> Rectify typing error while including the guard for the header
> file xdi_msg.h so that proper guard is wrapped around the file
> to prevent it from being included more than once.

> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

    You need to specify "eicon: " in the patch subjects, else there's an 
impression you're modifying the generic ISDN code instead of the concrete 
driver. You might as well drop "drivers:".

WBR, Sergei

