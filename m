Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaISApu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 20:45:50 -0400
Received: from mail-by2on0102.outbound.protection.outlook.com ([207.46.100.102]:35974
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750720AbaISApt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 20:45:49 -0400
Message-ID: <541B7947.2070901@freescale.com>
Date: Thu, 18 Sep 2014 19:31:03 -0500
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Kim Phillips <kim.phillips@freescale.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<stuart.yoder@freescale.com>" <stuart.yoder@freescale.com>,
        "<scottwood@freescale.com>" <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 0/4] drivers/bus: Freescale Management Complex bus driver
 patch series
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com> <20140915184423.2189d18282c9c2030e564f7c@freescale.com> <541A253F.7030305@freescale.com> <B83A7221-35BF-4E20-8AC4-333A2C0A39B7@suse.de>
In-Reply-To: <B83A7221-35BF-4E20-8AC4-333A2C0A39B7@suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.50]
X-ClientProxiedBy: DM2PR04CA057.namprd04.prod.outlook.com (10.141.154.175) To
 BY2PR03MB330.namprd03.prod.outlook.com (10.141.139.18)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6049001)(6009001)(51704005)(189002)(24454002)(377454003)(199003)(479174003)(83506001)(36756003)(106356001)(83322001)(50466002)(20776003)(64706001)(76176999)(101416001)(97736003)(87266999)(50986999)(77096002)(85306004)(90102001)(102836001)(81342003)(99396002)(54356999)(46102003)(85852003)(47776003)(105586002)(66066001)(42186005)(79102003)(87976001)(65956001)(65816999)(92726001)(33656002)(31966008)(95666004)(21056001)(76482002)(86362001)(110136001)(80022003)(4396001)(23746002)(92566001)(80316001)(74662003)(74502003)(77982003)(81542003)(93886004)(107046002)(83072002)(59896002)(65806001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB330;H:[10.214.83.219];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/18/2014 07:58 AM, Alexander Graf wrote:

>>
>>> checkpatch:
>>>
>>> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
>>>
>>> WARNING: DT compatible string "fsl,qoriq-mc" appears un-documented -- check ./Documentation/devicetree/bindings/
>>> #690: FILE: drivers/bus/fsl-mc/fsl_mc_bus.c:528:
>>> +    {.compatible = "fsl,qoriq-mc",},
>>>
>>> For the former warning, I'd suggest moving patch 4/4's contents up
>>> in the series.
>> I tried moving 4/4 to be 1/4 but still get the the same warning from checkpatch. So, this suggestion does not work. Besides, I took a look
>> at other commits that update the MAINTAINERS such as
>> 563da3a90364fc29cd09bed034162592e591747a, and that commit comes after the commits that added the new files.
>
> The alternative would be to add MAINTAINERS entries for the files you add in the patch that adds the files.
>
I tried this but still get the checpatch warning:

WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?

Still, I will add MAINTAINERS entries in each patch that adds files, 
instead of having a separate patch just for that.

>
> Alex
>
