Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab3ICRq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:46:59 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:6088 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163Ab3ICRq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:46:58 -0400
Message-ID: <52262090.3030803@tilera.com>
Date: Tue, 3 Sep 2013 13:46:56 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v2] tile: support KVM for tilegx
References: <52091682.8020004@siemens.com> <201308122037.r7CKbo99011833@farm-0021.internal.tilera.com> <20130825113953.GN8218@redhat.com> <521AAED7.4080407@tilera.com> <20130826120445.GD8218@redhat.com> <52261D26.7060206@tilera.com> <20130903173931.GO10142@redhat.com>
In-Reply-To: <20130903173931.GO10142@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/2013 1:39 PM, Gleb Natapov wrote:
> On Tue, Sep 03, 2013 at 01:32:22PM -0400, Chris Metcalf wrote:
>> Ping!  I'd like to ask Linus to pull the tile tree now that 3.12 is open.
>> Let me know if this would be problematic for you.  
>>
> That was sent to close to merge window and I and Paolo had vocations in
> August so with the email backlog we had no time to review it. Lets wait
> for 2.13 and I will give its review top priority after the merge
> windows.

Thanks, I've pulled it from linux-tile for now.  I'll put it back (for linux-next) after Linus pulls the remainder of the tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

