Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3AUSSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:18:55 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:39813 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab3AUSSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:18:53 -0500
Message-ID: <50FD8676.9090203@linux.vnet.ibm.com>
Date: Mon, 21 Jan 2013 10:18:30 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Gleb Natapov <gleb@redhat.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 4/5] create slow_virt_to_phys()
References: <20130121175244.E5839E06@kernel.stglabs.ibm.com> <20130121175249.AFE9EAD7@kernel.stglabs.ibm.com> <2ad09c09-98c3-4b2d-9b3f-f16fbcce4edf@email.android.com>
In-Reply-To: <2ad09c09-98c3-4b2d-9b3f-f16fbcce4edf@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012118-7408-0000-0000-00000C1491B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 10:08 AM, H. Peter Anvin wrote:
> Why are you initializing psize/pmask?

It's an artifact from the switch() that was there before.  I'll clean it up.

