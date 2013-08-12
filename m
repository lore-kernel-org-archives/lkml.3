Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab3HLVI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 17:08:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53303 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab3HLVIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 17:08:55 -0400
Message-ID: <52094ED2.1000308@zytor.com>
Date: Mon, 12 Aug 2013 14:08:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linn Crosetto <linn@hp.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, yinghai@kernel.org,
        penberg@kernel.org, jacob.shin@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: selective remapping in parse_setup_data()
References: <1376341206-72835-1-git-send-email-linn@hp.com>
In-Reply-To: <1376341206-72835-1-git-send-email-linn@hp.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 02:00 PM, Linn Crosetto wrote:
> PCI devices may advertise a ROM size larger than early_memremap() is
> able to handle. If this occurs it leads to a NULL dereference in
> parse_setup_data(). Avoid this by remapping the data only when
> necessary.
> 
> Signed-off-by: Linn Crosetto <linn@hp.com>

I think you need to clarify the various subcases (the code looks right,
but the explanation needs to be improved.)

	-hpa

