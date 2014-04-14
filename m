Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbaDNRIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:08:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48272 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbaDNRIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:08:32 -0400
Message-ID: <534C15F2.105@zytor.com>
Date: Mon, 14 Apr 2014 10:08:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de, JBeulich@suse.com
Subject: Re: [PATCH V3 1/1] X86: Probe for PIC and set legacy_pic appropriately
References: <1397497584-23717-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1397497584-23717-1-git-send-email-kys@microsoft.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 10:46 AM, K. Y. Srinivasan wrote:
> +	new_val = inb(PIC_MASTER_IMR);
> +	if (probe_val != new_val) {

Nitpick: Linux coding style should have this as:

	if (new_val != probe_val)

	-hpa


