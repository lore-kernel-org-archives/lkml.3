Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab3BUL2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 06:28:48 -0500
Received: from multi.imgtec.com ([194.200.65.239]:28282 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab3BUL2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 06:28:47 -0500
Message-ID: <512604EB.3030805@imgtec.com>
Date: Thu, 21 Feb 2013 11:28:43 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] metag: copy devicetree to non-init memory
References: <1361371929-28148-1-git-send-email-james.hogan@imgtec.com> <1361371929-28148-2-git-send-email-james.hogan@imgtec.com> <512602C4.1090400@synopsys.com>
In-Reply-To: <512602C4.1090400@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_21_11_28_45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/02/13 11:19, Vineet Gupta wrote:
> On Wednesday 20 February 2013 08:22 PM, James Hogan wrote:
>> Make a copy of the device tree blob in non-init memory. It is required
>> when using built-in device tree files that the platform code copies the
>> blob to non-init memory prior to calling unflatten_device_tree(),
>> otherwise the strings that the device tree refer to will get poisoned
>> and potentially reused, breaking later reading of the device tree
>> post-init (such as compatible matching in modules, debugfs, and the
>> procfs interface).
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> 
> In case you need it - Reviewed-by: Vineet Gupta <vgupta@synopsys.com>

Thanks Vineet,

Cheers
James

