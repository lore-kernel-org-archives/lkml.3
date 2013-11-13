Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab3KMCM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 21:12:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42813 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756693Ab3KMCMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 21:12:21 -0500
Message-ID: <5282DFF0.5050108@zytor.com>
Date: Tue, 12 Nov 2013 18:12:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, tglx@linutronix.de,
        trenn@suse.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/microcode/amd: Tone down printk(), don'
 t treat a missing firmware file as an error
References: <1384274383-43510-1-git-send-email-trenn@suse.de> <tip-11f918d3e2d3861b6931e97b3aa778e4984935aa@git.kernel.org> <20131112224511.GJ12854@pd.tnic> <20131112230016.GA30674@gmail.com>
In-Reply-To: <20131112230016.GA30674@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 03:00 PM, Ingo Molnar wrote:
> 
> Indeed that is the documented alias, although stable@kernel.org works as 
> well and is used frequently:
> 

No, it doesn't; it has bounced for the past two years.

	-hpa


