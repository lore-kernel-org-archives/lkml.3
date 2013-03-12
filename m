Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676Ab3CLVux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:50:53 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:58978
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932732Ab3CLVuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:50:51 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz31h2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: RE: [PATCH 1/1] Drivers: hv: Add a new driver to support host
 initiated backup
Thread-Topic: [PATCH 1/1] Drivers: hv: Add a new driver to support host
 initiated backup
Thread-Index: AQHOH07TqDjlqB8wR0CoK/U1aqy2q5iiZc2AgAAiMvA=
Date: Tue, 12 Mar 2013 21:49:10 +0000
Message-ID: <514a60e04f3c4ccb813ae68dc888d32f@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1363114406-30575-1-git-send-email-kys@microsoft.com>
 <20130312184839.GA30976@aepfle.de>
In-Reply-To: <20130312184839.GA30976@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.147.76]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%IOREMAP.NET$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC102.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(13464002)(377454001)(189002)(199002)(24454001)(6806001)(63696002)(44976002)(50466001)(56816002)(74662001)(59766001)(31966008)(66066001)(80022001)(54316002)(76482001)(46102001)(49866001)(47976001)(47736001)(74502001)(47446002)(65816001)(23676001)(51856001)(53806001)(33646001)(77982001)(56776001)(69226001)(20776003)(16676001)(79102001)(47776003)(4396001)(50986001)(54356001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB020;H:TK5EX14HUBC102.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 078310077C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2CLoqoG018454



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Tuesday, March 12, 2013 2:49 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; apw@canonical.com; jasowang@redhat.com;
> Evgeniy Polyakov
> Subject: Re: [PATCH 1/1] Drivers: hv: Add a new driver to support host initiated
> backup
> 
> On Tue, Mar 12, K. Y. Srinivasan wrote:
> 
> > +static int vss_operate(int operation)
> > +{
> > +	char *fs_op;
> > +	char cmd[512];
> > +	char buf[512];
> > +	FILE *file;
> > +	char *p;
> > +	char *x;
> > +	int error;
> > +
> > +	switch (operation) {
> > +	case VSS_OP_FREEZE:
> > +		fs_op = "-f ";
> > +		break;
> > +	case VSS_OP_THAW:
> > +		fs_op = "-u ";
> > +		break;
> > +	}
> > +
> > +	sprintf(cmd, "%s", "mount | grep ^/dev/ | awk '{print $3 }'");
> 
> I think this can be char cmd[] = "mount | awk '/^\/dev\/ { print $3'";

Yes; will make the change.
> 
> > +	file = popen(cmd, "r");
> > +	if (file == NULL)
> > +		return;
> > +
> > +	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
> > +		x = strchr(p, '\n');
> > +		*x = '\0';
> > +		if (!strncmp(p, "/", sizeof("/")))
> > +			continue;
> > +
> > +		sprintf(cmd, "%s %s %s", "fsfreeze ", fs_op, p);
> > +		syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
> > +		error = system(cmd);
> 
> error is not handled here, and it looks like only one error can be
> reported anyway.
> In case of an error, will the host thaw the filesystems?

Both freeze and thaw operations will not fail if properly applied. The only time the
freeze operation fails is when there is already an active freeze in force. Likewise,
the only time thaw fails is when there has not been a preceding freeze operation. So these
errors will occur only when the VM user happens to be applying freeze/thaw operations
independent of the host. In this case, the host simply reports an error on the host on
the backup operation and nothing else is done.

Regards,

K. Y 
> 
> > +	}
> > +	pclose(file);
> > +
> > +	sprintf(cmd, "%s %s %s", "fsfreeze ", fs_op, "/");
> > +	syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
> > +	error = system(cmd);
> > +
> > +	return error;
> > +}
> 
> 

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
