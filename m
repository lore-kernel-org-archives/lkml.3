Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbaLHQ5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:57:01 -0500
Received: from mail-by2on0056.outbound.protection.outlook.com ([207.46.100.56]:22266
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755087AbaLHQ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:56:59 -0500
Message-ID: <5485D7B5.2@opensource.altera.com>
Date: Mon, 8 Dec 2014 10:54:13 -0600
From: Graham Moore <grmoore@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Alan Tull <atull@opensource.altera.com>,
        Yves Vandervennet <yvanderv@opensource.altera.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2/2] mtd: spi-nor: Add driver for Cadence Quad SPI Flash
 Controller.
References: <1417808133-20719-1-git-send-email-grmoore@opensource.altera.com> <1417808133-20719-3-git-send-email-grmoore@opensource.altera.com> <CACna6ry0WBwcqH74sub-C=e0oGsPEoqXZ4O7uAwGcJC9Zc2zJw@mail.gmail.com>
In-Reply-To: <CACna6ry0WBwcqH74sub-C=e0oGsPEoqXZ4O7uAwGcJC9Zc2zJw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR08CA0062.namprd08.prod.outlook.com (10.141.200.42) To
 BLUPR03MB438.namprd03.prod.outlook.com (10.141.78.149)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB438;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:BLUPR03MB438;
X-Forefront-PRVS: 041963B986
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(479174003)(377454003)(199003)(51704005)(24454002)(189002)(50466002)(76176999)(33656002)(65956001)(66066001)(23676002)(558084003)(77096005)(65806001)(31966008)(1411001)(4396001)(50986999)(77156002)(110136001)(62966003)(87976001)(120916001)(47776003)(64126003)(105586002)(20776003)(42186005)(97736003)(92566001)(122386002)(21056001)(106356001)(86362001)(46102003)(68736005)(83506001)(65816999)(99396003)(107046002)(101416001)(40100003)(54356999);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB438;H:[137.57.160.195];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB438;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/05/2014 04:30 PM, Rafał Miłecki wrote:
> Since my commit
> mtd: spi-nor: allow NULL as chip name and try to auto detect it
> second argument is optional.
>
> Can you simply pass NULL instead of modalias?
>

OK, passing NULL.  Works fine for me, thanks.

-Graham
