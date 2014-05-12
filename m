Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbaELQlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:41:05 -0400
Received: from usevmg20.ericsson.net ([198.24.6.45]:50749 "EHLO
	usevmg20.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaELQlC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:41:02 -0400
X-AuditID: c618062d-f79c96d000001cfc-65-5370aa57eb06
From: Jon Maloy <jon.maloy@ericsson.com>
To: Willy Tarreau <w@1wt.eu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ying Xue <ying.xue@windriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [ 072/143] tipc: fix lockdep warning during bearer
 initialization
Thread-Topic: [ 072/143] tipc: fix lockdep warning during bearer
 initialization
Thread-Index: AQHPbYNfLH68r/y1C0KWrEcC7KLEnps9HIwAgABGeQD//8O+0A==
Date: Mon, 12 May 2014 16:41:00 +0000
Message-ID: <A2BAEFC30C8FD34388F02C9B3121859D1C250675@eusaamb103.ericsson.se>
References: <20140512003203.627061916@1wt.eu>
 <5370F0F0.1020606@ericsson.com> <20140512161613.GD19173@1wt.eu>
In-Reply-To: <20140512161613.GD19173@1wt.eu>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [147.117.188.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsUyuXRPuG7EqoJgg66dTBZzzrewWFzeNYfN
	4tre48wWCzY+YrQ4Pn8Oo8Xj69eZHdg8Tk/fz+yxZeVNJo/Pm+Q81m/ZyhTAEsVlk5Kak1mW
	WqRvl8CVMXNWfEEHW8Wi6bNYGxjfs3QxcnJICJhI9L85wwphi0lcuLeerYuRi0NI4CijxOzJ
	dxghnOWMEkcv32cDqWIT0JB4Oa2DEcQWEZCRaJo6nQWkiFngK6PEhDf/mEESwgIBEn2/t7JA
	FAVKzH98hB3CdpLY/2InWDOLgKrEng+zgeIcHLwCvhJ312qAhIUE8iV+v/gCVsIpoCPRevAd
	WCujgKzE7rPXmUBsZgFxiVtP5jNBXC0gsWTPeWYIW1Ti5eN/UN8oSUxaeo4Vol5HYsHuT2wQ
	trbEsoWvwep5BQQlTs58wjKBUWwWkrGzkLTMQtIyC0nLAkaWVYwcpcWpZbnpRgabGIHxdUyC
	TXcH456XlocYBTgYlXh4F8wuCBZiTSwrrsw9xCjNwaIkzlvwJTZYSCA9sSQ1OzW1ILUovqg0
	J7X4ECMTB6dUA2P5XImaMxk60zRebgz/+XZzuVDWqynyiss4GC9ldLLrieYwL401iD0wqeDL
	8ZxzARlO8a+4jKfZXvtQUMpVdmXi9vSnBVE7pJVun9eMZ214pKLtWvPn1IRgJh8tMV2bU3Ev
	VjXkXrHqe//kywIuzhCXIuapc9VLr0mab0hiT1w5f31HSNWVOiWW4oxEQy3mouJEACRdUMmQ
	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I should have mentioned that it is still only in net-next.
It is pretty recent.

///jon

> -----Original Message-----
> From: Willy Tarreau [mailto:w@1wt.eu]
> Sent: May-12-14 12:16 PM
> To: Jon Maloy
> Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; Ying Xue; Paul
> Gortmaker; David S. Miller
> Subject: Re: [ 072/143] tipc: fix lockdep warning during bearer initialization
> 
> On Mon, May 12, 2014 at 12:04:00PM -0400, Jon Maloy wrote:
> > This one is obsolete.
> > tipc_net_lock does not exist in the current code. It was removed in commit
> >  7216cd949c9bd56a4ccd952c624ab68f8c9aa0a4("tipc: purge tipc_net_lock
> lock")
> 
> I'm a bit confused, I can't find this commit, in what branch is it ?
> 
> Thanks,
> Willy

