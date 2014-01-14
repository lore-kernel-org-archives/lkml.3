Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaANP76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:59:58 -0500
Received: from plane.gmane.org ([80.91.229.3]:49253 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaANP74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:59:56 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH 0/3] power_supply: modelgauge_battery: Add Maxim ModelGauge
 ICs gauge
Date: Tue, 14 Jan 2014 16:59:42 +0100
Message-ID: <52D55EEE.3060502@samsung.com>
References: <1389286145-15375-1-git-send-email-vladimir.barinov@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: devicetree@vger.kernel.org
X-Gmane-NNTP-Posting-Host: 217-67-201-162.itsa.net.pl
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
In-Reply-To: <1389286145-15375-1-git-send-email-vladimir.barinov@cogentembedded.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 05:49 PM, Vladimir Barinov wrote:
> This adds the folowing:
> - Maxim ModelGauge ICs gauge driver for MAX17040/41/43/44/48/49/58/59 chips
> - Document DT bindings
> - Remove superseded Maxim MAX17040 gauge driver
>
> Vladimir Barinov (3):
>   [1/3] power_supply: modelgauge_battery: Maxim ModelGauge ICs gauge
>   [2/3] dt: Document ModelGauge gauge bindings
>   [3/3] power_supply: modelgauge_battery: Remove Maxim MAX17040 gauge

On which tree your patchset is based on? I had conflicts when trying to 
apply this on 3.12 and 3.13.

Best regards,
Krzysztof


