Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaD1XQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:16:21 -0400
Received: from [207.46.163.209] ([207.46.163.209]:14890 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751515AbaD1XQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:16:20 -0400
X-WSS-ID: 0N4RJXQ-07-AD3-02
X-M-MSG: 
Message-ID: <535EDDAF.8000604@amd.com>
Date: Mon, 28 Apr 2014 18:01:03 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "mingo@kernel.org" <mingo@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jacob.w.shin@gmail.com" <jacob.w.shin@gmail.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hurwitz, Sherry" <sherry.hurwitz@amd.com>
Subject: Re: [PATCH V6 0/4] perf/x86/amd: AMD Family 16h Data Breakpoint Extensions
References: <1386764906-1681-1-git-send-email-suravee.suthikulpanit@amd.com>
 <52CDA054.4010700@amd.com> <20140109015251.GA7398@localhost.localdomain>
 <530CB229.2020303@amd.com> <20140225154921.GB22814@localhost.localdomain>
In-Reply-To: <20140225154921.GB22814@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(41574002)(164054003)(51914003)(24454002)(51704005)(189002)(199002)(479174003)(377454003)(86362001)(50466002)(64126003)(33656001)(36756003)(65816999)(46102001)(74662001)(575784001)(2009001)(31966008)(81342001)(92726001)(74502001)(81542001)(101416001)(79102001)(19580395003)(80022001)(99396002)(80316001)(4396001)(76482001)(1411001)(84676001)(23756003)(92566001)(80976001)(20776003)(87936001)(97736001)(65806001)(76176999)(77982001)(83506001)(54356999)(85852003)(50986999)(47776003)(87266999)(77096999)(44976005)(65956001)(83322001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR02MB117;H:atltwp01.amd.com;FPR:97F67ED0.E711ACB2.7C7FF7BA.C8C8F9D9.20169;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 01952C6E96
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/25/2014 9:49 AM, Frederic Weisbecker wrote:
> This message has been archived. View the original item
> <http://ausev2.amd.com/EnterpriseVault/ViewMessage.asp?VaultId=1EBD12133601C6E47868220A36CFE2B201110000amdvault.amd.com&SavesetId=201403275961891~201402251548080000~Z~F07F5E04B0F823C085F9DFEECF2BA521>
> On Tue, Feb 25, 2014 at 09:09:29AM -0600, Suravee Suthikulanit wrote:
>  > On 1/8/2014 7:52 PM, Frederic Weisbecker wrote:
>  > >This message has been archived. View the original item
>  >
>  ><http://ausev2.amd.com/EnterpriseVault/ViewMessage.asp?VaultId=1EBD12133601C6E47868220A36CFE2B201110000amdvault.amd.com&SavesetId=201402081892875~201401090153030000~Z~D12198340FA0E3A8078F6DDADF1DAC51>
>  > >Hi Suravee,
>  > >
>  > >On Wed, Jan 08, 2014 at 01:00:36PM -0600, Suravee Suthikulanit wrote:
>  > > > Ping.  Are there any other concerns regarding this patch?
>  > > >
>  > > > Thank you,
>  > > >
>  > > > Suravee
>  > >
>  > >The patches look good. I'll apply the series and propose it to the perf
>  > >maintainers.
>  > >
>  > >Thanks!
>  > >
>  >
>  > Frederic,
>  >
>  > I am following up with this patch set.
>
> Thanks for the reminder. I'm applying this right now and will propose
> for 3.15.
>
> Thanks.
>

Frederic,

I am still not seeing these patch set in the 3.15.0-rc3.  Are you still 
planning to include this in the 3.15?

Thanks,

Suravee
