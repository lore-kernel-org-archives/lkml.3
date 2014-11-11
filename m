Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaKKH5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:57:11 -0500
Received: from mail-bn1bon0077.outbound.protection.outlook.com ([157.56.111.77]:5976
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751758AbaKKH5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 02:57:09 -0500
Date: Tue, 11 Nov 2014 08:56:53 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Steve Wang <steven.wang@digilentinc.com>,
        Peter Crosthwaite <crosthwaitepeter@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
        =?windows-1252?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        <sorenb@xilinx.com>
Subject: Re: [PATCH 2/2] arm: dts: zynq: Add Digilent ZYBO board
References: <CAPokK=ohd6L=ExZ7xQCGpEDj=BbN6RUec2F+=Trz3BCn1Nw-sQ@mail.gmail.com>,
	<1415504283-31321-1-git-send-email-crosthwaite.peter@gmail.com>
	<1415504283-31321-2-git-send-email-crosthwaite.peter@gmail.com>
	<548fd9c6edf94ca2b20299895f78b139@BN1AFFO11FD036.protection.gbl>
	<CAPokK=ovsR--ARj-2rNV6udbPEPqy4bChqC5FJw-u6O=cnHZQA@mail.gmail.com>
	<a7677222807f4dd3a7d74df647e48598@BL2FFO11FD053.protection.gbl>
 <OFCF68BFE0.14A043A7-ON86257D8D.000BF746-86257D8D.000BF749@ni.com>
In-Reply-To: <OFCF68BFE0.14A043A7-ON86257D8D.000BF746-86257D8D.000BF749@ni.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21092.000
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <9d1dd4f735e247c38a333dfd3aafd2f8@BN1AFFO11FD027.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(377424004)(189002)(377454003)(479174003)(52034003)(24454002)(52044002)(164054003)(199003)(31966008)(23746002)(87936001)(95666004)(99396003)(21056001)(120916001)(50466002)(46102003)(19580395003)(19580405001)(77156002)(108616004)(93886004)(62966003)(64126003)(92566001)(50986999)(54356999)(86362001)(107046002)(64706001)(47776003)(74316001)(102836001)(104016003)(6806004)(106466001)(83506001)(33646002)(44976005)(20776003)(76176999)(4396001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB064;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB064;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB064;
X-Forefront-PRVS: 0392679D18
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB064;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think you can simple use "digilent".
The first step is to send the patch with add digilent to
Documentation/devicetree/bindings/vendor-prefixes.txt

and then feel free to send patch for fixing digilent,zed
+ zybo dts.

Thanks,
Michal


On 11/11/2014 03:10 AM, Steve Wang wrote:
> Hi, Peter,
> 
> According to naming convention, I think "dglnt" is good enough ^.^
> 
> By the way, I think there is a need to address another issue that needs to be 
> addressed for ZYBO as well (maybe in a separate thread):
> MAC address pre-load from on-board EEPROM.
> I think ZYBO might still be the only Zynq-based board that has an on-board 
> EEPROM for MAC address as well.
> 
> Regards,
> Steve
> 
> -----Peter Crosthwaite <crosthwaitepeter@gmail.com> wrote: -----
> To: Sören Brinkmann <soren.brinkmann@xilinx.com>, Steve Wang 
> <steven.wang@digilentinc.com>
> From: Peter Crosthwaite <crosthwaitepeter@gmail.com>
> Date: 11/10/2014 02:56PM
> Cc: linux-kernel@vger.kernel.org, michals@xilinx.com, sorenb@xilinx.com
> Subject: Re: [PATCH 2/2] arm: dts: zynq: Add Digilent ZYBO board
> 
> On Tue, Nov 11, 2014 at 8:42 AM, Sören Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
>  > On Tue, 2014-11-11 at 08:39AM +1000, Peter Crosthwaite wrote:
>  >> On Mon, Nov 10, 2014 at 7:47 AM, Sören Brinkmann
>  >> <soren.brinkmann@xilinx.com> wrote:
>  >> > Hi Peter,
>  >> >
>  >> > On Sun, 2014-11-09 at 01:38PM +1000, Peter Crosthwaite wrote:
>  >> >> Add a DTS describing the Digilent ZYBO board. Similar to ZED but with
>  >> >
>  >> > "Digilent ZYBO" here...
>  >> >
>  >> > [...]
>  >> >> +/ {
>  >> >> +     model = "Zynq ZYBO Development Board";
>  >> >> +     compatible = "xlnx,zynq-zybo", "xlnx,zynq-7000";
>  >> >
>  >> > ... "xlnx,zynq-zybo" here. Seems inconsistent. IMHO, there should rather be
>  >> > a digilent vendor prefix.
>  >> >
>  >>
>  >> Was going for consistency with ZED which also makes this mistake:
>  >>
>  >>     model = "Zynq Zed Development Board";
>  >>     compatible = "xlnx,zynq-zed", "xlnx,zynq-7000";
>  >>
>  >> We have to choose between consistency and correctness. If we do fix it
>  >> though, what is Diglent's four-letter vendor prefix?
>  >
>  > Since Digilent is the board vendor, I'm for using the appropriate
>  > prefix. Vendor prefixes are found in
>  > Documentation/devicetree/bindings/vendor-prefixes.txt.
>  >
> 
> It's not there,
> 
> Steven, does Digilent have a preferred dts vendor prefix?
> 
> Regards,
> Peter
> 
>  >         Soren
> 

