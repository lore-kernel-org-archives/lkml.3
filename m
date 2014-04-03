Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaDCU5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:57:16 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:54349 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaDCU5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:57:12 -0400
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2014 16:57:12 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=yUolWZ
	FQUuXNnAVuMP+wAJiWAgLS3t2AJub2RLhhyUb1wlda8gTIGkJwD2Qd4dwW/QlEzJ
	O77/dwavxAszM6mZ75lr1xuvDHzl0xO2KJdszT+xvws4Tv/2X3fKtHdFnPvcFakL
	4JMmPhvUeil7H6Dz2tCTU+U2p0JJl6/RH9XcA=
Message-ID: <533DC9CA.6030508@pobox.com>
Date: Thu, 03 Apr 2014 16:51:22 -0400
From: Mark Lord <mlord@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: "J. Bruce Fields" <bfields@redhat.com>, Albert Fluegel <af@muc.de>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-3.14 nfsd regression
References: <533D8D73.1090603@pobox.com> <20140403171643.GB28790@pad.redhat.com> <533D9F8A.6030001@pobox.com> <20140403201533.GB8343@fieldses.org>
In-Reply-To: <20140403201533.GB8343@fieldses.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: B70131F4-BB71-11E3-B845-873F0E5B5709-82205200!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-04-03 04:15 PM, J. Bruce Fields wrote:
> On Thu, Apr 03, 2014 at 01:51:06PM -0400, Mark Lord wrote:
>> On 14-04-03 01:16 PM, J. Bruce Fields wrote:
>>> The original behavior was in practice harmless and changing it broke
>>> something, so I think we should definitely just revert this patch.
>>
>> Yup.  Who?
> 
> I'll submit this soon.
..

Thanks, Bruce!

-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
