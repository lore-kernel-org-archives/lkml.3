Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab3CGL4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:56:12 -0500
Received: from multi.imgtec.com ([194.200.65.239]:37938 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab3CGL4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:56:11 -0500
Message-ID: <51388042.5060309@imgtec.com>
Date: Thu, 7 Mar 2013 11:55:46 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] metag: Inhibit NUMA balancing.
References: <20130304011231.GA26475@linux-sh.org>
In-Reply-To: <20130304011231.GA26475@linux-sh.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_07_11_56_08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/13 01:12, Paul Mundt wrote:
> The metag NUMA implementation follows the SH model, using different nodes for
> memories with different latencies. As such, we ensure that automated balancing
> between nodes is inhibited, by way of the new ARCH_WANT_VARIABLE_LOCALITY.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Thanks Paul, Applied.

Cheers
James

