Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583Ab3KMQu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:50:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52543 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab3KMQuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:50:21 -0500
Message-ID: <5283ADB5.7080209@zytor.com>
Date: Wed, 13 Nov 2013 08:49:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>,
        Christian Ruppert <christian.ruppert@abilis.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Uncompressed kernel doesn't build on x86_64
References: <20131113113418.167b8ffd@IRBT4585>
In-Reply-To: <20131113113418.167b8ffd@IRBT4585>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 08:34 AM, Pavel Roskin wrote:
> 
> Any suggestions for uncompressed suffix?  I'd go with "copy".  Then the
> "compression" could be a symlink.  Alternatively, the "." could be
> included in other suffixes, the uncompressed suffix would be empty and
> the compression would be an empty statement.
> 

The latter would be my preference.

	-hpa

