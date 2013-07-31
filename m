Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab3GaKRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:17:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39340 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab3GaKRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:17:21 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-00-51f8e42e4551
Message-id: <51F8E404.6070507@partner.samsung.com>
Date: Wed, 31 Jul 2013 12:16:36 +0200
From: Piotr Sarna <p.sarna@partner.samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, b.zolnierkie@samsung.com,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/2] staging: zram: add Crypto API support
References: <1375187449-6546-1-git-send-email-p.sarna@partner.samsung.com>
 <20130730135333.GB27962@kroah.com>
In-reply-to: <20130730135333.GB27962@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jQV29Jz8CDR5c1LTYOGM9q8WeM7/Y
	LZoXr2ezONv0ht3i8q45bBYbWmaxO7B53Nt3mMVj/9w17B59W1Yxeuz8tJnV4/MmuQDWKC6b
	lNSczLLUIn27BK6M253PGQtmcVZc/9jB3MA4i72LkZNDQsBEYvLK3UwQtpjEhXvr2boYuTiE
	BKYzSnQ9fswO4bxmlNj26CgLSBWvgJHE3M8vmEFsFgFViQdTl4HF2QT0Jb5cXwNkc3CICkRI
	HF2uCVEuKPFj8j2wEhEBDYmXR2+xgMxkFpjBKHFp33+wzcICdhJrDm4EmykkkC+xsLcJ7DpO
	oJnXP8xhBLGZBXQk9rdOY4Ow5SU2r3nLPIFRYBaSHbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFe
	cWJucWleul5yfu4mRnBwP5PewbiqweIQowAHoxIP74xL3wOFWBPLiitzDzFKcDArifDKB/0I
	FOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cAY4t+SorJv
	304LxeVyobxsB08lOQgLdiiebndxCLnS/25KVcfznu9XHOJbpnSJzemKFm1cPSNFt2BOXcG2
	k3pMe5+UGH5gT3TV6NU+u/159TtHfYmpS4pvGry1OzDZ3vjn3C83Pv/sL5rCsGKSn8v0nT7X
	58+5eNHM3/n7+ZKmt5Nthd2auLuUWIozEg21mIuKEwGJjC/3agIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/30/2013 03:53 PM, Greg KH wrote:
> On Tue, Jul 30, 2013 at 02:30:48PM +0200, Piotr Sarna wrote:
>> Current version of zram does not allow any substitution of a default
>> compression algorithm. Therefore, I decided to change the existing
>> implementation of page compression by adding Crypto API compability.
> 
> As I have stated before, I want this code to get merged out of the
> drivers/staging/ area _before_ any new features get added to it.  People
> are taking too much time adding new stuff, like this, and no one seems
> to be working to get it merged to the proper place anymore.
> 

OK, but we actually need those features in order to test zram
against other, competitive solutions - and then decide whether
and how to merge it out of /drivers/staging.

> So again, I'm going to have to say no to a new feature here, sorry.
> zcache, zram, and zsmalloc need to get cleaned up and merged out of
> staging before anything new can be added to them.
> 
> Or, if no one is working on that, I guess I can just delete them,
> right?...
> 

Is there any official TODO list of cleaning up and merging out zram?

Regards,
Piotr Sarna
