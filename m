Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbaDNNH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:07:56 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:38845 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755062AbaDNNHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:07:53 -0400
Message-ID: <534BDDA3.3080005@codethink.co.uk>
Date: Mon, 14 Apr 2014 14:07:47 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Iyappan Subramanian <isubramanian@apm.com>, davem@davemloft.net,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com,
        Ravi Patel <rapatel@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Subject: Re: [PATCH v2 0/4] net: Add APM X-Gene SoC Ethernet driver support
References: <1397271984-23405-1-git-send-email-isubramanian@apm.com>
In-Reply-To: <1397271984-23405-1-git-send-email-isubramanian@apm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/14 04:06, Iyappan Subramanian wrote:
> This patch series adds support for the APM X-Gene SoC Ethernet driver.
>
> v2
> * Completely redesigned ethernet driver
> * Added support to work with big endian kernel
> * Renamed dtb phyid entry to phy_addr
> * Changed dtb local-mac-address entry to byte string format
> * Renamed dtb eth8clk entry to menetclk

Patch 2/4 seems to have vanished?

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
