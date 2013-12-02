Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab3LBMpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:45:13 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:35414 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752494Ab3LBMpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:45:10 -0500
Message-ID: <529C80D3.3090200@hurleysoftware.com>
Date: Mon, 02 Dec 2013 07:45:07 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] perf Makefile: Correct the message in feature-libnuma
 checking.
References: <529C9DFD.6040707@cn.fujitsu.com> <1385998008-6851-1-git-send-email-yangds.fnst@cn.fujitsu.com> <529BF100.2080504@hurleysoftware.com> <20131202122620.GA2371@ghostprotocols.net>
In-Reply-To: <20131202122620.GA2371@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 07:26 AM, Arnaldo Carvalho de Melo wrote:
> Em Sun, Dec 01, 2013 at 09:31:28PM -0500, Peter Hurley escreveu:
>> On 12/02/2013 10:26 AM, Dongsheng Yang wrote:
>>> The package required for numa is named numactl-devel in Fedora or RHEL,
>>> and libnuma-devel in OpenSuSE, and libnuma-dev in Ubuntu. This patch
>>> corrects the package name in warning message in feature-libnuma checking.
>>
>> Thanks (and thanks for correcting the other lib names).
>
> I'll take this as an:
>
> Acked-by: Peter Hurley <peter@hurleysoftware.com>
>
> Ok?

Yes, ok.

Regards,
Peter Hurley

