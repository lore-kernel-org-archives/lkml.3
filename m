Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3KDQcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:32:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47605 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab3KDQcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:32:05 -0500
Message-ID: <5277CBF2.1030806@zytor.com>
Date: Mon, 04 Nov 2013 08:31:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Josh Boyer <jwboyer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, prarit@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Allow NR_CPUS=1024
References: <20131101141148.GH8652@hansolo.jdub.homelinux.org> <20131103101825.GA6605@gmail.com> <20131103102132.GA6807@gmail.com> <20131103155729.GB9944@hansolo.jdub.homelinux.org> <52768B48.5030408@zytor.com> <20131104065147.GB13030@gmail.com>
In-Reply-To: <20131104065147.GB13030@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2013 10:51 PM, Ingo Molnar wrote:
> 
> randconfig will not randomize numeric Kconfig ranges, so there's no other 
> mechanism right now to trigger those large config kernels.
> 

Sounds like the real problem...

	-hpa


