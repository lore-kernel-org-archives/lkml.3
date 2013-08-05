Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab3HENSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:18:23 -0400
Received: from multi.imgtec.com ([194.200.65.239]:15567 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab3HENSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:18:20 -0400
Message-ID: <51FFA5CD.3010406@imgtec.com>
Date: Mon, 5 Aug 2013 14:17:01 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: <linux-mips@linux-mips.org>, <ralf@linux-mips.org>, <kvm@vger.kernel.org>,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>,
        <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 1/3] mips/kvm: Improve code formatting in arch/mips/kvm/kvm_locore.S
References: <1375388555-4045-1-git-send-email-ddaney.cavm@gmail.com> <1375388555-4045-2-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1375388555-4045-2-git-send-email-ddaney.cavm@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_08_05_14_18_14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 01/08/13 21:22, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> No code changes, just reflowing some comments and consistently using
> tabs and spaces.  Object code is verified to be unchanged.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> Acked-by: Ralf Baechle <ralf@linux-mips.org>


> +   	 /* Put the saved pointer to vcpu (s1) back into the DDATA_LO Register */

git am detects a whitespace error here ("space before tab in indent").
It's got spaces before and after the tab actually.

>      /* load the guest context from VCPU and return */

this comment could have it's indentation fixed too

Otherwise, for all 3 patches:

Reviewed-by: James Hogan <james.hogan@imgtec.com>

Thanks
James

