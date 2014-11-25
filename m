Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaKYHfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:35:30 -0500
Received: from smtprelay06.ispgateway.de ([80.67.31.96]:33856 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbaKYHf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:35:27 -0500
Message-ID: <54743139.3090104@ladisch.de>
Date: Tue, 25 Nov 2014 08:35:21 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nicolas George <george@nsup.org>, linux-kernel@vger.kernel.org
Subject: Re: Using kernel filesystems as userland libraries
References: <20141124131200.GA28582@phare.normalesup.org>
In-Reply-To: <20141124131200.GA28582@phare.normalesup.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas George wrote:
> With the libraries present in e2fsprogs, it is possible to open a plain file
> (or any other reasonable storage) as an EXT2 filesystem and manipulate files
> inside it.
>
> Is it possible to use the implementations in the kernel to do the same thing
> with any supported normal filesystem?

mount -o loop /plain/file /where/to/mount
