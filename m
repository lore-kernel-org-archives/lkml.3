Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaHaU67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 16:58:59 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:22108
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751693AbaHaU64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 16:58:56 -0400
Date: Sun, 31 Aug 2014 13:58:50 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Joe Perches <joe@perches.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <devel@driverdev.osuosl.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        <kernelnewbies@kernelnewbies.org>, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] checkpatch: Remove unnecessary + after {8,8}
References: <1405128087.6751.12.camel@joe-AO725>
 <20140712013927.GA30781@kroah.com> <1405129612.6751.24.camel@joe-AO725>
 <20140712020114.GA12301@kroah.com> <20140712020520.GA18611@kroah.com>
 <1405130970.6751.37.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405130970.6751.37.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20918.005
X-TM-AS-Result: No--1.650-5.0-31-1
X-imss-scan-details: No--1.650-5.0-31-1
Message-ID: <7d350fb4-2a54-4b3f-b81c-6c0737ff32fb@BY2FFO11FD028.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(164054003)(377424004)(189002)(24454002)(199003)(85852003)(83072002)(21056001)(92566001)(83322001)(86362001)(92726001)(4396001)(102836001)(70736001)(85182001)(76176999)(54356999)(50986999)(81542001)(99396002)(77982001)(76482001)(20776003)(23676002)(80022001)(47776003)(79102001)(81342001)(31966008)(74662001)(64706001)(83506001)(6806004)(106466001)(50466002)(85202003)(1496007)(46102001)(104016003)(85306004)(74316001)(110136001)(74502001)(93886004)(44976005)(87936001)(31696002)(53416004)(107046002)(77096002)(90102001)(95666004)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB043;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0320B28BE1
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Fri, 2014-07-11 at 07:09PM -0700, Joe Perches wrote:
> There's a useless "+" use that needs to be removed as perl 5.20
> emits a "Useless use of greediness modifier '+'" message each
> time it's hit.

I saw this Perl warning today as well and wondered whether this patch is
coming or not. Apparently it's not in linux-next (yet).

	Thanks,
	Sören
