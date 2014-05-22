Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaEVV6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:58:11 -0400
Received: from zimbra.real-time.com ([63.170.91.9]:56986 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaEVV6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:58:07 -0400
Date: Fri, 23 May 2014 07:57:50 +1000
From: James Cameron <quozl@laptop.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        kernel-janitors@vger.kernel.org, libertas-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>
Subject: Re: [PATCH] libertas: fix return value when processing invalid packet
Message-ID: <20140522215750.GF2161@us.netrek.org>
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
 <1400473875-22228-2-git-send-email-Julia.Lawall@lip6.fr>
 <5379FCD0.2030506@cogentembedded.com>
 <1400520341.3819.15.camel@dcbw.local>
 <1400761961.15674.4.camel@dcbw.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400761961.15674.4.camel@dcbw.local>
Organization: Netrek Vanilla Server Dictator
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 07:32:41AM -0500, Dan Williams wrote:
> Nothing actually uses the return value yet, but we might as well
> make it correct, like process_rxed_802_11_packet() does for the
> same case.  Also ensure that if monitor mode is enabled (and
> thus process_rxed_802_11_packet() is called) that the debugging
> enter/leave functions are balanced.
> 
> Signed-off-by: Dan Williams <dcbw@redhat.com>

Reviewed-by: James Cameron <quozl@laptop.org>

-- 
James Cameron
http://quozl.linux.org.au/
