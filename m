Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaBVTbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 14:31:22 -0500
Received: from jcornwall.me ([198.58.100.172]:46972 "EHLO jcornwall.me"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaBVTbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 14:31:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 22 Feb 2014 13:31:19 -0600
From: Jay Cornwall <jay@jcornwall.me>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org
Subject: Re: =?UTF-8?Q?put=5Fpage=20on=20transparent=20huge=20page=20leaks?=
 =?UTF-8?Q?=3F?=
In-Reply-To: <2f724688447dc8c8e599ff07fccb9fa4@jcornwall.me>
References: <ff08f2ccbcd50d2d353392a81defe619@jcornwall.me>
 <20140222023144.GB18046@node.dhcp.inet.fi>
 <2f724688447dc8c8e599ff07fccb9fa4@jcornwall.me>
Message-ID: <3104bf891faf02691e4f2e0de44a59a9@jcornwall.me>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-22 11:44, Jay Cornwall wrote:
> On 2014-02-21 20:31, Kirill A. Shutemov wrote:
>> On Fri, Feb 21, 2014 at 11:23:39AM -0600, Jay Cornwall wrote:
>>> I'm tracking a possible memory leak in iommu/amd. The driver uses 
>>> this logic
>>> to fault a page in response to a PRI from a device:
> 
> The head page appears to be leaking a reference. There is *no leak* if
> the driver faults the head page directly.

My apologies, this was fixed somewhere in the patch series: "mm: tail 
page refcounting optimization for slab and hugetlbfs" (Jan 22nd).

Our merge was slightly older than I'd thought.
