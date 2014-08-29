Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaH2TSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:18:12 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:55981 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199AbaH2TSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:18:11 -0400
Message-ID: <5400D1F2.6020900@akamai.com>
Date: Fri, 29 Aug 2014 15:18:10 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Jones <rob.jones@codethink.co.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cl@linux-foundation.org" <cl@linux-foundation.org>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "mpm@selenic.com" <mpm@selenic.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@codethink.co.uk" <linux-kernel@codethink.co.uk>
Subject: Re: [PATCH 4/4] lib: Use seq_open_private() instead of seq_open()
References: <1409328400-18212-1-git-send-email-rob.jones@codethink.co.uk> <1409328400-18212-5-git-send-email-rob.jones@codethink.co.uk>
In-Reply-To: <1409328400-18212-5-git-send-email-rob.jones@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2014 12:06 PM, Rob Jones wrote:
> Using seq_open_private() removes boilerplate code from ddebug_proc_open()
>

Looks good.

Acked-by: Jason Baron <jbaron@akamai.com>
