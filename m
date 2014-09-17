Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbaIQQBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:01:08 -0400
Received: from nbfkord-smmo04.seg.att.com ([209.65.160.86]:54079 "EHLO
	nbfkord-smmo04.seg.att.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754870AbaIQQBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:01:06 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Sep 2014 12:01:06 EDT
X-MXL-Hash: 5419b0425a62637c-30e186aa53d8e0432ee2752c7625c001c0382f2a
X-MXL-Hash: 5419ae9e0a7c2f17-d99cb57f9e7c9e59e8b8426eb99b7e513c5c4261
Message-ID: <5419AE97.4040803@solarflare.com>
Date: Wed, 17 Sep 2014 16:53:59 +0100
From: Robert Stonehouse <rstonehouse@solarflare.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>, <linux-pci@vger.kernel.org>,
        <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci: quirks: Add ACS quirk for Solarflare SFC9120 & SFC9140
References: <20140917145838.19243.14630.stgit@gimli.home>
In-Reply-To: <20140917145838.19243.14630.stgit@gimli.home>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.111]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20956.005
X-TM-AS-Result: No--2.062700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-AnalysisOut: [v=2.0 cv=Osb4PVDt c=1 sm=1 a=MkjXnYnS3dyNWGSWLXxFFQ==:17 a]
X-AnalysisOut: [=C9B2r7mWgu8A:10 a=S-_dVS6G22MA:10 a=Mzdm9TVJApsA:10 a=4ox]
X-AnalysisOut: [owH2qkH0A:10 a=V7e5eIXYnG0A:10 a=BLceEmwcHowA:10 a=IkcTkHD]
X-AnalysisOut: [0fZMA:10 a=zRKbQ67AAAAA:8 a=20KFwNOVAAAA:8 a=j6NyL1U_zftb3]
X-AnalysisOut: [0EDMPoA:9 a=QEXdDO2ut3YA:10 a=sii_dYzwqpYA:10 a=jEp0ucaQiE]
X-AnalysisOut: [UA:10 a=1Dwx9gnmAe4A:10 a=gUpuluK-jq0A:10 a=zuimZLHZ4bwA:1]
X-AnalysisOut: [0]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2014051901)]
X-MAIL-FROM: <rstonehouse@solarflare.com>
X-SOURCE-IP: [12.187.104.25]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/09/14 15:59, Alex Williamson wrote:
> Solarflare confirms that these devices do not allow peer-to-peer
> between functions.  Quirk them to allow IOMMU grouping to expose this
> isolation.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: Robert Stonehouse <rstonehouse@solarflare.com>

Acked-by: Robert Stonehouse <rstonehouse@solarflare.com>



