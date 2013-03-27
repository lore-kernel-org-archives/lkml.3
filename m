Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab3C0ThI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:37:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42153 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab3C0ThH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:37:07 -0400
Message-ID: <51534942.5020009@zytor.com>
Date: Wed, 27 Mar 2013 12:32:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Cody P Schafer <cody@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/3] x86/mm/numa: use setup_nr_node_ids() instead of opencoding.
References: <1364319962-30967-1-git-send-email-cody@linux.vnet.ibm.com> <1364319962-30967-3-git-send-email-cody@linux.vnet.ibm.com> <CAE9FiQVSPdCqaLKapG4DJ1CXtPKb8F29=s_-e9OLpXP7yG1XTA@mail.gmail.com>
In-Reply-To: <CAE9FiQVSPdCqaLKapG4DJ1CXtPKb8F29=s_-e9OLpXP7yG1XTA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 10:56 AM, Yinghai Lu wrote:
> 
> For 1 and 2,
> 
> Acked-by: Yinghai Lu <yinghai@kernel.org>
> 

Similarly:

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

	-hpa

