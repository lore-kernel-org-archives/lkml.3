Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab3IMToG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:44:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50993 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab3IMToE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:44:04 -0400
Message-ID: <52336AF5.3040104@zytor.com>
Date: Fri, 13 Sep 2013 12:43:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kernel Fedora <kernel@lists.fedoraproject.org>
Subject: Re: Fedora Kernel Patch Report
References: <CA+5PVA7Y-r67u7K5R5XJOEcyCmyTe9Q8fJNQr=6-i1n6QitrPA@mail.gmail.com>
In-Reply-To: <CA+5PVA7Y-r67u7K5R5XJOEcyCmyTe9Q8fJNQr=6-i1n6QitrPA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 12:07 PM, Josh Boyer wrote:
> 
> crash-driver.patch
>   - The patch to add /dev/crash.  Dave Anderson keeps making this work (mostly).
> 

It is also a security hole.

	-hpa


