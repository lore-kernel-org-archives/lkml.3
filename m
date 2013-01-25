Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3AYXQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 18:16:09 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56044 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab3AYXQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 18:16:04 -0500
Message-ID: <51031227.6010000@linux.vnet.ibm.com>
Date: Fri, 25 Jan 2013 15:15:51 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Gleb Natapov <gleb@redhat.com>, "H.Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/5] [v3] fix illegal use of __pa() in KVM code
References: <20130122212428.8DF70119@kernel.stglabs.ibm.com>
In-Reply-To: <20130122212428.8DF70119@kernel.stglabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012523-7182-0000-0000-000004B81321
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 01:24 PM, Dave Hansen wrote:
> This series fixes a hard-to-debug early boot hang on 32-bit
> NUMA systems.  It adds coverage to the debugging code,
> adds some helpers, and eventually fixes the original bug I
> was hitting.

I got one more reviewed-by on this set, but otherwise no more comments.
 Could these get pulled in to the x86 tree for merging in 3.9?

