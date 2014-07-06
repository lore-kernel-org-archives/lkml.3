Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaGFNmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 09:42:20 -0400
Received: from libra.uberspace.de ([95.143.172.171]:34043 "EHLO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaGFNmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 09:42:18 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jul 2014 09:42:17 EDT
Date: Sun, 6 Jul 2014 15:32:19 +0200
From: Matthias Beyer <mail@beyermatthias.de>
To: Pawel Lebioda <pawel.lebioda89@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: bcm: add missing blank lines after declarations
Message-ID: <20140706133219.GB25985@fu.3gs>
Reply-To: Matthias Beyer <mail@beyermatthias.de>
References: <20140704203024.GA11946@ThinkPad>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <20140704203024.GA11946@ThinkPad>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04-07-2014 22:30:27, Pawel Lebioda wrote:
> Hi,
>=20
> This patch fixes almost all 'missing blank line after declaration'
> warnings reported by checkpatch.pl for drivers/staging/bcm.
>=20
> Regards
> Pawel Lebioda
>=20
> Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>
>  drivers/staging/bcm/CmHost.c        | 1 +
>  drivers/staging/bcm/IPv6Protocol.c  | 6 ++++++
>  drivers/staging/bcm/InterfaceDld.c  | 1 +
>  drivers/staging/bcm/InterfaceInit.c | 1 +
>  drivers/staging/bcm/InterfaceMisc.c | 1 +
>  drivers/staging/bcm/InterfaceTx.c   | 2 +-
>  drivers/staging/bcm/PHSModule.c     | 1 +
>  drivers/staging/bcm/Qos.c           | 9 ++++++++-
>  drivers/staging/bcm/Transmit.c      | 1 +
>  drivers/staging/bcm/led_control.c   | 4 ++++
>  drivers/staging/bcm/nvm.c           | 6 ++++++
>  11 files changed, 31 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
> index 3dbdf0e..adca0ce 100644
> --- a/drivers/staging/bcm/CmHost.c
> +++ b/drivers/staging/bcm/CmHost.c
> @@ -972,6 +972,7 @@ static VOID DumpCmControlPacket(PVOID pvBuffer)
>  		pstAddIndication->sfAuthorizedSet.bValid =3D 1;
>  	for (nIndex =3D 0; nIndex < nCurClassifierCnt; nIndex++) {
>  		struct bcm_convergence_types *psfCSType =3D NULL;
> +
>  		psfCSType =3D  &pstAddIndication->sfAuthorizedSet.cConvergenceSLTypes[=
nIndex];
> =20
>  		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL, "=
psfCSType =3D %p", psfCSType);
> diff --git a/drivers/staging/bcm/IPv6Protocol.c b/drivers/staging/bcm/IPv=
6Protocol.c
> index cd16067..e013c5a 100644
> --- a/drivers/staging/bcm/IPv6Protocol.c
> +++ b/drivers/staging/bcm/IPv6Protocol.c
> @@ -45,6 +45,7 @@ static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayl=
oad,
>  	case IPV6HDR_TYPE_ROUTING:
>  		{
>  			struct bcm_ipv6_routing_hdr *pstIpv6RoutingHeader;
> +
>  			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
>  					DBG_LVL_ALL, "\nIPv6 Routing Header");
>  			pstIpv6RoutingHeader =3D (struct bcm_ipv6_routing_hdr *)pucPayloadPtr;
> @@ -66,6 +67,7 @@ static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayl=
oad,
>  		{
>  			struct bcm_ipv6_dest_options_hdr *pstIpv6DestOptsHdr =3D (struct bcm_=
ipv6_dest_options_hdr *)pucPayloadPtr;
>  			int nTotalOptions =3D pstIpv6DestOptsHdr->ucHdrExtLen;
> +
>  			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
>  					DBG_LVL_ALL,
>  					"\nIPv6 DestOpts Header Header");
> @@ -78,6 +80,7 @@ static UCHAR *GetNextIPV6ChainedHeader(UCHAR **ppucPayl=
oad,
>  		{
>  			struct bcm_ipv6_authentication_hdr *pstIpv6AuthHdr =3D (struct bcm_ip=
v6_authentication_hdr *)pucPayloadPtr;
>  			int nHdrLen =3D pstIpv6AuthHdr->ucLength;
> +
>  			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG,
>  					DBG_LVL_ALL,
>  					"\nIPv6 Authentication Header");
> @@ -275,6 +278,7 @@ USHORT	IpVersion6(struct bcm_mini_adapter *Adapter, P=
VOID pcIpHeader,
> =20
>  	if (bClassificationSucceed =3D=3D TRUE) {
>  		INT iMatchedSFQueueIndex =3D 0;
> +
>  		iMatchedSFQueueIndex =3D SearchSfid(Adapter, pstClassifierRule->ulSFID=
);
>  		if (iMatchedSFQueueIndex >=3D NO_OF_QUEUES) {
>  			bClassificationSucceed =3D false;
> @@ -407,6 +411,7 @@ VOID DumpIpv6Address(ULONG *puIpv6Address)
>  	UINT uiIpv6AddrNoLongWords =3D 4;
>  	UINT uiIpv6AddIndex =3D 0;
>  	struct bcm_mini_adapter *Adapter =3D GET_BCM_ADAPTER(gblpnetdev);
> +
>  	for (uiIpv6AddIndex =3D 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIp=
v6AddIndex++) {
>  		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
>  				":%lx", puIpv6Address[uiIpv6AddIndex]);
> @@ -419,6 +424,7 @@ static VOID DumpIpv6Header(struct bcm_ipv6_hdr *pstIp=
v6Header)
>  	UCHAR ucVersion;
>  	UCHAR ucPrio;
>  	struct bcm_mini_adapter *Adapter =3D GET_BCM_ADAPTER(gblpnetdev);
> +
>  	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
>  			"----Ipv6 Header---");
>  	ucVersion =3D pstIpv6Header->ucVersionPrio & 0xf0;
> diff --git a/drivers/staging/bcm/InterfaceDld.c b/drivers/staging/bcm/Int=
erfaceDld.c
> index e1925bd..abc7a7a 100644
> --- a/drivers/staging/bcm/InterfaceDld.c
> +++ b/drivers/staging/bcm/InterfaceDld.c
> @@ -244,6 +244,7 @@ static INT buffDnld(struct bcm_mini_adapter *Adapter,
>  {
>  	unsigned int len =3D 0;
>  	int retval =3D STATUS_SUCCESS;
> +
>  	len =3D u32FirmwareLength;
> =20
>  	while (u32FirmwareLength) {
> diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/In=
terfaceInit.c
> index bef13a6..bb61d34 100644
> --- a/drivers/staging/bcm/InterfaceInit.c
> +++ b/drivers/staging/bcm/InterfaceInit.c
> @@ -440,6 +440,7 @@ static int select_alternate_setting_for_highspeed_mod=
em(
>  			 * Else USB_IF will fail.
>  			 */
>  			UINT _uiData =3D ntohl(EP2_CFG_INT);
> +
>  			BCM_DEBUG_PRINT(psAd, DBG_TYPE_INITEXIT, DRV_ENTRY,
>  					DBG_LVL_ALL,
>  					"Reverting Bulk to INT as it is in Full Speed mode.\n");
> diff --git a/drivers/staging/bcm/InterfaceMisc.c b/drivers/staging/bcm/In=
terfaceMisc.c
> index 4173fd7..61a81dc 100644
> --- a/drivers/staging/bcm/InterfaceMisc.c
> +++ b/drivers/staging/bcm/InterfaceMisc.c
> @@ -208,6 +208,7 @@ void putUsbSuspend(struct work_struct *work)
>  {
>  	struct bcm_interface_adapter *psIntfAdapter =3D NULL;
>  	struct usb_interface *intf =3D NULL;
> +
>  	psIntfAdapter =3D container_of(work, struct bcm_interface_adapter, usbS=
uspendWork);
>  	intf =3D psIntfAdapter->interface;
> =20
> diff --git a/drivers/staging/bcm/InterfaceTx.c b/drivers/staging/bcm/Inte=
rfaceTx.c
> index ea7707b..e113a7d 100644
> --- a/drivers/staging/bcm/InterfaceTx.c
> +++ b/drivers/staging/bcm/InterfaceTx.c
> @@ -161,8 +161,8 @@ static int TransmitTcb(struct bcm_interface_adapter *=
psIntfAdapter, struct bcm_u
>  int InterfaceTransmitPacket(PVOID arg, PVOID data, UINT len)
>  {
>  	struct bcm_usb_tcb *pTcb =3D NULL;
> -
>  	struct bcm_interface_adapter *psIntfAdapter =3D arg;
> +
>  	pTcb =3D GetBulkOutTcb(psIntfAdapter);
>  	if (pTcb =3D=3D NULL) {
>  		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_PRINTK, 0, 0, "No U=
RB to transmit packet, dropping packet");
> diff --git a/drivers/staging/bcm/PHSModule.c b/drivers/staging/bcm/PHSMod=
ule.c
> index bd68c6f..4b6de76 100644
> --- a/drivers/staging/bcm/PHSModule.c
> +++ b/drivers/staging/bcm/PHSModule.c
> @@ -287,6 +287,7 @@ int phs_init(struct bcm_phs_extension *pPhsdeviceExte=
nsion, struct bcm_mini_adap
>  	pstServiceFlowTable =3D pPhsdeviceExtension->pstServiceFlowPhsRulesTabl=
e;
>  	for (i =3D 0; i < MAX_SERVICEFLOWS; i++) {
>  		struct bcm_phs_entry sServiceFlow =3D pstServiceFlowTable->stSFList[i];
> +
>  		sServiceFlow.pstClassifierTable =3D kzalloc(sizeof(struct bcm_phs_clas=
sifier_table), GFP_KERNEL);
>  		if (!sServiceFlow.pstClassifierTable) {
>  			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, PHS_DISPATCH, DBG_LVL_ALL, =
"\nAllocation failed");
> diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
> index 42c1351..c5213b3 100644
> --- a/drivers/staging/bcm/Qos.c
> +++ b/drivers/staging/bcm/Qos.c
> @@ -94,8 +94,8 @@ static bool MatchDestIpAddress(struct bcm_classifier_ru=
le *pstClassifierRule, UL
>  ************************************************************************=
**/
>  static bool MatchTos(struct bcm_classifier_rule *pstClassifierRule, UCHA=
R ucTypeOfService)
>  {
> -
>  	struct bcm_mini_adapter *Adapter =3D GET_BCM_ADAPTER(gblpnetdev);
> +
>  	if (3 !=3D pstClassifierRule->ucIPTypeOfServiceLength)
>  		return TRUE;
> =20
> @@ -121,6 +121,7 @@ bool MatchProtocol(struct bcm_classifier_rule *pstCla=
ssifierRule, UCHAR ucProtoc
>  {
>  	UCHAR ucLoopIndex =3D 0;
>  	struct bcm_mini_adapter *Adapter =3D GET_BCM_ADAPTER(gblpnetdev);
> +
>  	if (0 =3D=3D pstClassifierRule->ucProtocolLength)
>  		return TRUE;
>  	for (ucLoopIndex =3D 0; ucLoopIndex < pstClassifierRule->ucProtocolLeng=
th; ucLoopIndex++) {
> @@ -269,6 +270,7 @@ static USHORT	IpVersion4(struct bcm_mini_adapter *Ada=
pter,
> =20
>  	if (TRUE =3D=3D bClassificationSucceed) {
>  		INT iMatchedSFQueueIndex =3D 0;
> +
>  		iMatchedSFQueueIndex =3D SearchSfid(Adapter, pstClassifierRule->ulSFID=
);
>  		if (iMatchedSFQueueIndex >=3D NO_OF_QUEUES)
>  			bClassificationSucceed =3D false;
> @@ -580,6 +582,7 @@ USHORT ClassifyPacket(struct bcm_mini_adapter *Adapte=
r, struct sk_buff *skb)
>  			 * Create Frag CLS Entry
>  			 */
>  			struct bcm_fragmented_packet_info stFragPktInfo;
> +
>  			stFragPktInfo.bUsed =3D TRUE;
>  			stFragPktInfo.ulSrcIpAddress =3D pIpHeader->saddr;
>  			stFragPktInfo.usIpIdentification =3D pIpHeader->id;
> @@ -601,6 +604,7 @@ static bool EthCSMatchSrcMACAddress(struct bcm_classi=
fier_rule *pstClassifierRul
>  {
>  	UINT i =3D 0;
>  	struct bcm_mini_adapter *Adapter =3D GET_BCM_ADAPTER(gblpnetdev);
> +
>  	if (pstClassifierRule->ucEthCSSrcMACLen =3D=3D 0)
>  		return TRUE;
>  	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s\n", _=
_func__);
> @@ -617,6 +621,7 @@ static bool EthCSMatchDestMACAddress(struct bcm_class=
ifier_rule *pstClassifierRu
>  {
>  	UINT i =3D 0;
>  	struct bcm_mini_adapter *Adapter =3D GET_BCM_ADAPTER(gblpnetdev);
> +
>  	if (pstClassifierRule->ucEthCSDestMACLen =3D=3D 0)
>  		return TRUE;
>  	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL, "%s\n", __=
func__);
> @@ -632,6 +637,7 @@ static bool EthCSMatchDestMACAddress(struct bcm_class=
ifier_rule *pstClassifierRu
>  static bool EthCSMatchEThTypeSAP(struct bcm_classifier_rule *pstClassifi=
erRule, struct sk_buff *skb, struct bcm_eth_packet_info *pstEthCsPktInfo)
>  {
>  	struct bcm_mini_adapter *Adapter =3D GET_BCM_ADAPTER(gblpnetdev);
> +
>  	if ((pstClassifierRule->ucEtherTypeLen =3D=3D 0) ||
>  		(pstClassifierRule->au8EthCSEtherType[0] =3D=3D 0))
>  		return TRUE;
> @@ -719,6 +725,7 @@ static bool EThCSClassifyPkt(struct bcm_mini_adapter =
*Adapter, struct sk_buff *s
>  				B_UINT8 EthCSCupport)
>  {
>  	bool bClassificationSucceed =3D false;
> +
>  	bClassificationSucceed =3D EthCSMatchSrcMACAddress(pstClassifierRule, (=
(struct bcm_eth_header *)(skb->data))->au8SourceAddress);
>  	if (!bClassificationSucceed)
>  		return false;
> diff --git a/drivers/staging/bcm/Transmit.c b/drivers/staging/bcm/Transmi=
t.c
> index 4976746..cd27bd8 100644
> --- a/drivers/staging/bcm/Transmit.c
> +++ b/drivers/staging/bcm/Transmit.c
> @@ -148,6 +148,7 @@ int SetupNextSend(struct bcm_mini_adapter *Adapter,  =
struct sk_buff *Packet, USH
>  				status);
>  	} else {
>  		struct net_device_stats *netstats =3D &Adapter->dev->stats;
> +
>  		Adapter->PackInfo[QueueIndex].uiTotalTxBytes +=3D Leader.PLength;
> =20
>  		netstats->tx_bytes +=3D Leader.PLength;
> diff --git a/drivers/staging/bcm/led_control.c b/drivers/staging/bcm/led_=
control.c
> index 8353677..074fc39 100644
> --- a/drivers/staging/bcm/led_control.c
> +++ b/drivers/staging/bcm/led_control.c
> @@ -6,6 +6,7 @@
>  static B_UINT16 CFG_CalculateChecksum(B_UINT8 *pu8Buffer, B_UINT32 u32Si=
ze)
>  {
>  	B_UINT16 u16CheckSum =3D 0;
> +
>  	while (u32Size--) {
>  		u16CheckSum +=3D (B_UINT8)~(*pu8Buffer);
>  		pu8Buffer++;
> @@ -16,6 +17,7 @@ static B_UINT16 CFG_CalculateChecksum(B_UINT8 *pu8Buffe=
r, B_UINT32 u32Size)
>  bool IsReqGpioIsLedInNVM(struct bcm_mini_adapter *Adapter, UINT gpios)
>  {
>  	INT Status;
> +
>  	Status =3D (Adapter->gpioBitMap & gpios) ^ gpios;
>  	if (Status)
>  		return false;
> @@ -489,6 +491,7 @@ static int ReadConfigFileStructure(struct bcm_mini_ad=
apter *Adapter,
>  	PUCHAR puCFGData	=3D NULL;
>  	UCHAR bData =3D 0;
>  	struct bcm_led_state_info *curr_led_state;
> +
>  	memset(GPIO_Array, DISABLE_GPIO_NUM, NUM_OF_LEDS+1);
> =20
>  	if (!Adapter->pstargetparams || IS_ERR(Adapter->pstargetparams)) {
> @@ -715,6 +718,7 @@ static void handle_adapter_driver_state(struct bcm_mi=
ni_adapter *ad,
>  			UCHAR GPIO_num_rx =3D DISABLE_GPIO_NUM;
>  			UCHAR uiLEDTx =3D 0;
>  			UCHAR uiLEDRx =3D 0;
> +
>  			currdriverstate =3D NORMAL_OPERATION;
>  			ad->LEDInfo.bIdle_led_off =3D false;
> =20
> diff --git a/drivers/staging/bcm/nvm.c b/drivers/staging/bcm/nvm.c
> index 99b82d8..8ce4d41 100644
> --- a/drivers/staging/bcm/nvm.c
> +++ b/drivers/staging/bcm/nvm.c
> @@ -361,6 +361,7 @@ int BeceemEEPROMBulkRead(struct bcm_mini_adapter *Ada=
pter,
>  		} else {
>  			/* Handle the reads less than 4 bytes... */
>  			PUCHAR pCharBuff =3D (PUCHAR)pBuffer;
> +
>  			pCharBuff +=3D uiIndex;
>  			if (ReadBeceemEEPROM(Adapter, uiOffset, &uiData[0]) =3D=3D 0) {
>  				memcpy(pCharBuff, &uiData[0], uiBytesRemaining); /* copy only bytes =
requested. */
> @@ -914,6 +915,7 @@ static int flashWriteStatus(struct bcm_mini_adapter *=
Adapter,
>  static VOID BcmRestoreBlockProtectStatus(struct bcm_mini_adapter *Adapte=
r, ULONG ulWriteStatus)
>  {
>  	unsigned int value;
> +
>  	value =3D (FLASH_CMD_WRITE_ENABLE << 24);
>  	wrmalt(Adapter, FLASH_SPI_CMDQ_REG, &value, sizeof(value));
> =20
> @@ -1154,6 +1156,7 @@ static int BeceemFlashBulkWrite(struct bcm_mini_ada=
pter *Adapter,
>  			if (STATUS_SUCCESS =3D=3D BeceemFlashBulkRead(Adapter, (PUINT)ucReadB=
k, uiOffsetFromSectStart + uiIndex, MAX_RW_SIZE)) {
>  				if (Adapter->ulFlashWriteSize =3D=3D 1) {
>  					unsigned int uiReadIndex =3D 0;
> +
>  					for (uiReadIndex =3D 0; uiReadIndex < 16; uiReadIndex++) {
>  						if (ucReadBk[uiReadIndex] !=3D pTempBuff[uiIndex + uiReadIndex]) {
>  							if (STATUS_SUCCESS !=3D (*Adapter->fpFlashWriteWithStatusCheck)(A=
dapter, uiPartOffset + uiIndex + uiReadIndex, &pTempBuff[uiIndex+uiReadInde=
x])) {
> @@ -1868,6 +1871,7 @@ int BeceemNVMWrite(struct bcm_mini_adapter *Adapter,
>  			if ((uiOffset + uiNumBytes) > EEPROM_CALPARAM_START) {
>  				ULONG ulBytesTobeSkipped =3D 0;
>  				PUCHAR pcBuffer =3D (PUCHAR)pBuffer; /* char pointer to take care of=
 odd byte cases. */
> +
>  				uiNumBytes -=3D (EEPROM_CALPARAM_START - uiOffset);
>  				ulBytesTobeSkipped +=3D (EEPROM_CALPARAM_START - uiOffset);
>  				uiOffset +=3D (EEPROM_CALPARAM_START - uiOffset);
> @@ -2455,6 +2459,7 @@ static int BcmGetFlashCSInfo(struct bcm_mini_adapte=
r *Adapter)
>  	#endif
> =20
>  	unsigned int uiFlashLayoutMajorVersion;
> +
>  	Adapter->uiFlashLayoutMinorVersion =3D 0;
>  	Adapter->uiFlashLayoutMajorVersion =3D 0;
>  	Adapter->ulFlashControlSectionStart =3D FLASH_CS_INFO_START_ADDR;
> @@ -4319,6 +4324,7 @@ static int ReadISOSignature(struct bcm_mini_adapter=
 *Adapter, enum bcm_flash2x_s
>  static int ReadISOPriority(struct bcm_mini_adapter *Adapter, enum bcm_fl=
ash2x_section_val iso)
>  {
>  	unsigned int ISOPri =3D STATUS_FAILURE;
> +
>  	if (IsSectionWritable(Adapter, iso)) {
>  		if (ReadISOSignature(Adapter, iso) =3D=3D ISO_IMAGE_MAGIC_NUMBER) {
>  			BcmFlash2xBulkRead(Adapter,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Looks good.

Reviewed-by: Matthias Beyer <mail@beyermatthias.de>

--=20
Mit freundlichen Gr=FC=DFen,
Kind regards,
Matthias Beyer

Proudly sent with mutt.
Happily signed with gnupg.

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTuU/jAAoJEJi+S08gyg+UtS0P/0hh1yC9QDk50C8fjtzxCc4F
gaMRW9lkK4X42ouHBfWH1nJEHE8KRL4R7rh1it0wZmulSJf3pRgVbYNQIJJgP1mC
rxDyaZ/SD2H1ubtYZ8hBDk5aTHjMzcU7Okq+MVHzNGFxCWMscqH/SofeA230RFuj
K/ixd41WeHlu1bGbD0VdUSmibQcT9Kze3Yv+bLy5EPiQtM7VKAFba0WVHMR4P0v+
wI49k6g1E5bQISYNqcihRphOCvasbeVRpMRzzJ8Z6ja6RAhNn75D3dZV0LPA17Zl
v3eVDGdFL0wVvzqmAUZBRipQZOr4E+JX9t0nGkcZiMajiibE9NQhNw7p1f3QJDQg
R+2EIRSkxfwhEDompTOd22r1IT5ZANthKf5xD/7ux4+cYf/u3c4LlSzV4nWL4+x7
sTF874rxnSui8tbjS1fD2ttN8A24LwuCBbHY6E3VKqduIW4JInvvOaVx3wfuuK3/
hSMINTnShXg6RrVV7F7Y5DU88RryYBbBrQALGW1TGI+dQvFgfmMKHfOGM5tneV09
+HAl/zJ+mpJH1I/ze+RYzSIUlumY3BuFDZjvPRucU4Og2eTQKpd31A6+0DmZT0Gh
8fuYJBaZQa1yC1Vb4g9nxKgIGFmghfGqM3rCjSHSzyWf7AKVHk/a2yKbB/srvr84
WLJkPR4SdNmtSSv6fQa+
=W7fY
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
