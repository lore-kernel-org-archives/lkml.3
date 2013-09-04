Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760468Ab3IDTT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:19:56 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:34213 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab3IDTTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:19:54 -0400
Message-ID: <52278791.3010101@linux.vnet.ibm.com>
Date: Wed, 04 Sep 2013 14:18:41 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] rsxx: Handling failed pci_map_page on PowerPC
 and double free.
References: <20130904185902.GE24898@oc6784271780.ibm.com>
In-Reply-To: <20130904185902.GE24898@oc6784271780.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090419-0928-0000-0000-000001450443
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 01:59 PM, Philip J. Kelleher wrote:
> From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> 
> The rsxx driver was not checking the correct value during a
> pci_map_page failure. Fixing this also uncovered a
> double free if the bio was returned before it was
> broken up into indiviadual 4k dmas, that is also
> fixed here.
> 
> Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


