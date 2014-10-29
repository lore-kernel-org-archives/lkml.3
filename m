Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaJ2ACO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 20:02:14 -0400
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:37064 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914AbaJ2ACN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 20:02:13 -0400
Message-ID: <54502E7D.3050505@nexus-software.ie>
Date: Wed, 29 Oct 2014 00:02:05 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Reply-To: pure.logic@nexus-software.ie
Organization: Nexus Software
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: [PATCH] Don't enable F00F workaround on Intel Quark processors.
References: <20141028175753.GA12743@redhat.com>
In-Reply-To: <20141028175753.GA12743@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/14 17:57, Dave Jones wrote:
> The Intel Quark processor is a part of family 5, but does not have the
> F00F bug present in Pentiums of the same family.
> 
> Pentiums were models 0 through 8, Quark is model 9.

Tested - works, F00F removed from list of bugs in /proc/cpuinfo

	BOD

