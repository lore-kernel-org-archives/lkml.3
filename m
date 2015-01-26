Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbbAZQ6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:58:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:34694 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbbAZQ6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:58:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,469,1418112000"; 
   d="scan'208";a="656642887"
From: "Vick, Matthew" <matthew.vick@intel.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC: Alexander Duyck <alexander.h.duyck@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ethernet: fm10k: Actually drop 4 bits
Thread-Topic: [PATCH] ethernet: fm10k: Actually drop 4 bits
Thread-Index: AQHQN2+xwQuPicYglkaLrsR9ALJ30JzSo6uA
Date: Mon, 26 Jan 2015 16:58:13 +0000
Message-ID: <D0EBB1E6.6855F%matthew.vick@intel.com>
References: <1421967198-16667-1-git-send-email-linux@rasmusvillemoes.dk>
 <D0E81E0C.682EB%matthew.vick@intel.com> <87twzhknnl.fsf@rasmusvillemoes.dk>
In-Reply-To: <87twzhknnl.fsf@rasmusvillemoes.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.4.7.141117
x-originating-ip: [10.166.14.12]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BC1833DA4954844B8EA32498F76E075F@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/15, 4:50 PM, "Rasmus Villemoes" <linux@rasmusvillemoes.dk> wrote:

>On Sat, Jan 24 2015, "Vick, Matthew" <matthew.vick@intel.com> wrote:
>
>> Good catch! I noticed this too and was getting a patch together to
>>address
>> this.
>>
>> The difference is that I was planning on not silently accepting an
>>invalid
>> VLAN ID to begin with and returning FM10K_ERR_PARAM if the VLAN was
>> invalid, which I think is a better approach for this situation. If it's
>> alright with you, I'll generate the patch shortly and credit you via
>>your
>> Reported-by.
>
>Sure, do what you think is best.
>
>Rasmus

Sounds good. I'll get the patch created and validated through Jeff's tree.

Cheers,
Matthew

