Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab3BZPaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 10:30:05 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:62178 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759578Ab3BZPaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 10:30:03 -0500
Message-ID: <512CD4F7.806@pobox.com>
Date: Tue, 26 Feb 2013 10:29:59 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        desnoyers@efficios.com
Subject: Re: Reproduceable SATA lockup on 3.7.8 with SSD
References: <20130226002731.GC25875@merlins.org>
In-Reply-To: <20130226002731.GC25875@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2013 07:27 PM, Marc MERLIN wrote:
> Howdy,
>
> I seem to have the same problem (or similar) as Mathieu Desnoyers in
> https://lkml.org/lkml/2013/2/22/437
>
> I can reliably get my SSD to drop from the SATA bus given the right workload
> on linux.
>
> How can I tell if it's linux's fault of the drive's fault?

Manually force speed to 3.0 Gbps, then 1.5 Gbps, and see what happens.

Try module/kernel parameter libata.force=1.5Gbps or libata.force=3.0Gbps

	Jeff




