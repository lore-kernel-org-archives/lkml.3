Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaKXLgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:36:20 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:40676 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaKXLgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:36:18 -0500
Message-ID: <5473182F.6030206@acm.org>
Date: Mon, 24 Nov 2014 12:36:15 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>, Roland Dreier <roland@kernel.org>
CC: kernel-janitors@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@kernel.org>
Subject: Re: [PATCH 5/6] ib_srpt: fix error return code
References: <1416667159-9808-1-git-send-email-Julia.Lawall@lip6.fr> <1416667159-9808-6-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1416667159-9808-6-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/14 15:39, Julia Lawall wrote:
> Return a negative error code on failure.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

