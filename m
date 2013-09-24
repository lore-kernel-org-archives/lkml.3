Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab3IXPRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:17:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35975 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3IXPRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:17:10 -0400
Message-ID: <5241ACEA.6010402@canonical.com>
Date: Tue, 24 Sep 2013 11:16:58 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Francois Romieu <romieu@fr.zoreil.com>, mpatocka@redhat.com
CC: Mirko Lindner <mlindner@marvell.com>, linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>, netdev@vger.kernel.org,
        member graysky <graysky@archlinux.us>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [REGRESSION][BISECTED] skge: add dma_mapping check
References: <1379494844.2294.12.camel@ThinkPad-X230.localdomain>	 <20130918220819.GA11989@electric-eye.fr.zoreil.com> <1379581391.2403.5.camel@ThinkPad-X230.localdomain>
In-Reply-To: <1379581391.2403.5.camel@ThinkPad-X230.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 05:03 AM, Igor Gnatenko wrote:
> Please, send patch.
>
The patch is in mainline as of 3.12-rc2 as commit:

Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Thu Sep 19 14:13:17 2013 -0400

    skge: fix broken driver

I don't see that the commit was Cc'd to stable.  Mikulas, we might need
to send a request directly to the stable maintainers and reqeust that
the commit be pulled into stable, in case they didn't notice the request
in the commit message.
