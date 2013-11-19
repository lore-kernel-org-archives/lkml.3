Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab3KSN1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:27:32 -0500
Received: from multi.imgtec.com ([194.200.65.239]:47633 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab3KSN1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:27:30 -0500
Message-ID: <528B6740.1030402@imgtec.com>
Date: Tue, 19 Nov 2013 13:27:28 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Rob Herring <rob.herring@calxeda.com>, <devicetree@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] dt: Handle passed/built-in DT selection in early_init_dt_scan()
References: <5283A000.8090007@gmail.com> <1384859554-27268-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1384859554-27268-1-git-send-email-geert@linux-m68k.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_11_19_13_27_29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/11/13 11:12, Geert Uytterhoeven wrote:
> Let early_init_dt_scan() fall-back to the built-in DT if no DT was passed,
> or if it's invalid, so architectures don't have to duplicate this logic.
> 
> Suggested-by: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Reviewed-by: James Hogan <james.hogan@imgtec.com>

Thanks
James

