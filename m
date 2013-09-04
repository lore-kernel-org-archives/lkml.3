Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601Ab3IDTUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:20:10 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:39133 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760504Ab3IDTUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:20:08 -0400
Message-ID: <522787D9.6090807@linux.vnet.ibm.com>
Date: Wed, 04 Sep 2013 14:19:53 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] rsxx: Moving pci_map_page to prevent overflow.
References: <20130904185935.GF24898@oc6784271780.ibm.com>
In-Reply-To: <20130904185935.GF24898@oc6784271780.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090419-9332-0000-0000-0000014DDA0F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 01:59 PM, Philip J. Kelleher wrote:
> From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> 
> The pci_map_page function has been moved into our
> issued workqueue to prevent an us running out of
> mappable addresses on non-HWWD PCIe x8 slots. The
> maximum amount that can possible be mapped at one
> time now is: 255 dmas X 4 dma channels X 4096 Bytes.
> 
> Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


